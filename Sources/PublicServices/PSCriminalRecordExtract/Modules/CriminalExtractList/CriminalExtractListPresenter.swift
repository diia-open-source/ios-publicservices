import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractListAction: BasePresenter {
    typealias ViewModel = CriminalCertificateRequestMainViewModel
    var numberOfRows: Int { get }
    var currentType: CertificateStatus { get }
    func openContextMenu()
    func actionTapped(animated: Bool)
    func getViewModelFor(index: Int) -> ViewModel
    func loadCellsFor(category: CertificateStatus)
}

final class CriminalExtractListPresenter: CriminalExtractListAction {
    typealias ViewModel = CriminalCertificateRequestMainViewModel
    
	// MARK: - Properties
    
    var currentType: CertificateStatus {
        return _currentType
    }
    
    var numberOfRows: Int {
        switch _currentType {
        case .applicationProcessing:
            return processingCertModels.count
        case .done:
            return doneCertModels.count
        }
    }
    
    unowned var view: CriminalExtractListView
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let apiClient: CriminalExtractApiClientProtocol
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let bag = DisposeBag()
    private var _currentType: CertificateStatus
    private var doneCertModels = [CriminalExtractModel]()
    private var processingCertModels =  [CriminalExtractModel]()
    private var doneMessage: AttentionMessage?
    private var processMessage: AttentionMessage?
    private var didFetchSecondCategory: Bool = false
    private var didRetry = false
    
    private var currentStatusMessage: AttentionMessage? {
        switch currentType {
        case .applicationProcessing:
            return processMessage
        case .done:
            return doneMessage
        }
    }
    
    // MARK: - Init
    init(
        view: CriminalExtractListView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        preselectedType: CertificateStatus,
        apiClient: CriminalExtractApiClientProtocol,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self._currentType = preselectedType
        self.apiClient = apiClient
        self.networkingContext = networkingContext
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setupHeader(contextMenuProvider: contextMenuProvider)
        fetchCertificates(category: currentType)
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped(animated: Bool) {
        if let ratingServiceOpener = PackageConstants.ratingServiceOpener,
           let urlOpener = PackageConstants.urlOpener {
            flowCoordinator.replaceRoot(
                with: CriminalExtractIntroModule(
                    contextMenuItems: contextMenuProvider,
                    flowCoordinator: flowCoordinator,
                    requestModel: CriminalExtractRequestModel(),
                    сonfig: .init(ratingServiceOpener: ratingServiceOpener,
                                  networkingContext: networkingContext,
                                  urlOpener: urlOpener)
                ),
                animated: animated
            )
        }
    }
    
    func getViewModelFor(index: Int) -> ViewModel {
        let certModel: CriminalExtractModel
        switch _currentType {
        case .applicationProcessing:
            certModel = processingCertModels[index]
        case .done:
            certModel = doneCertModels[index]
        }
        return ViewModel(
            certificate: certModel,
            action: Action(
                title: R.Strings.general_details.localized(),
                iconName: nil,
                callback: { [weak self] in
                    guard let self = self else { return }
                    if let ratingServiceOpener = PackageConstants.ratingServiceOpener,
                       let urlOpener = PackageConstants.urlOpener {
                        self.view.open(
                            module: CriminalExtractRequestStatusModule(
                                contextMenuItems: self.contextMenuProvider,
                                flowCoordinator: self.flowCoordinator,
                                screenType: .ready,
                                applicationId: certModel.applicationId,
                                certificateDate: self.dateFromModel(certModel),
                                сonfig: .init(ratingServiceOpener: ratingServiceOpener,
                                              networkingContext: networkingContext,
                                              urlOpener: urlOpener)
                            )
                        )
                    }
                }
            )
        )
    }
    
    func loadCellsFor(category: CertificateStatus) {
        _currentType = category
        switch currentType {
        case .applicationProcessing:
            view.configureStubMessage(message: processMessage)
        case .done:
            view.configureStubMessage(message: doneMessage)
        }
        view.tableViewShouldReload()
    }
    
    // MARK: - Private Methods
    
    private func dateFromModel(_ extract: CriminalExtractModel) -> String? {
        let date = extract
            .creationDate
            .filter("0123456789.".contains)
            .components(separatedBy: ".")
            .reversed()
            .joined(separator: ".")
        return date
    }
    
    private func fetchCertificates(category: CertificateStatus) {
        view.setLoadingState(.loading)
        apiClient
            .getCriminalExtractList(category: category)
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let data):
                    self.handleResponse(response: data)
                case .failed(let error):
                    self.handleError(error: error) { [weak self] in
                        self?.fetchCertificates(category: category)
                    }
                default:
                    break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleResponse(response: TemplatedResponse<CriminalExtractListModel>) {
        switch response {
        case .data(let model):
            if let navigationPanel = model.navigationPanel {
                contextMenuProvider.setTitle(title: navigationPanel.header)
                contextMenuProvider.setContextMenu(items: navigationPanel.contextMenu)
            }
            handleListCertificates(response: model)
        case .template(let template):
            TemplateHandler.handle(template, in: self.view) { [weak self] action in
                if action == .skip {
                    self?.view.closeModule(animated: true)
                }
            }
        }
    }
    
    private func handleListCertificates(response: CriminalExtractListModel) {
        view.configureStubMessage(message: response.stubMessage)
        if let status = response.certificatesStatus {
            switch status.code {
            case .applicationProcessing:
                processMessage = response.stubMessage
                processingCertModels = response.certificates ?? []
            case .done:
                doneMessage = response.stubMessage
                doneCertModels = response.certificates ?? []
            }
            if didFetchSecondCategory {
                setupState()
            } else {
                didFetchSecondCategory.toggle()
                let category: CertificateStatus = _currentType == .done ? .applicationProcessing : .done
                fetchCertificates(category: category)
            }
            if status.code == _currentType { view.tableViewShouldReload() }
        }
    }
    
    private func setupState() {
        if processingCertModels.isEmpty && doneCertModels.isEmpty {
            actionTapped(animated: false)
        } else {
            view.setLoadingState(.ready)
            view.updateBackgroundColor()
            view.configureStubMessage(message: currentStatusMessage)
            view.setupHeader(contextMenuProvider: contextMenuProvider)
        }
    }
    
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: { [weak self] in
                self?.didRetry = true
                retryAction()
            },
            didRetry: didRetry,
            in: view
        )
    }
}
