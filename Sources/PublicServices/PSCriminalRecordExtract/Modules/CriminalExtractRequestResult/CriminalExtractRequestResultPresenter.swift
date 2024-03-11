import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractRequestResultAction: BasePresenter {
    func validateViewModel()
    func openContextMenu()
    func didTapActionButton()
    func geContactViewModel() -> CriminalExtractResultViewModel?
    var requestStatePercent: Float { get }
    var requestProgressSubtitle: String? { get }
}

final class CriminalExtractRequestResultPresenter: CriminalExtractRequestResultAction {
    
    // MARK: - Private Properties
    private let apiClient: CriminalExtractApiClientProtocol
    private let contextMenuProvider: ContextMenuProviderProtocol
    private var viewModel: CriminalExtractResultViewModel?
    private let flowCoordinator: CriminalExtractCoordinator
    private let requestModel: CriminalExtractRequestModel
    private var responseModel: CriminalExtractNewConfirmationModel?
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let disposebag = DisposeBag()
    private var didRetry = false
    
    // MARK: - Public Properties
    unowned var view: CriminalExtractRequestResultView
    var requestStatePercent: Float {
        return Float(8) / Float(8)
    }
    
    var requestProgressSubtitle: String? {
        return R.Strings.criminal_certificate_request_progress_label.formattedLocalized(arguments: 8, 8)
    }
    
    // MARK: - Initialization
    init(
        view: CriminalExtractRequestResultView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        apiClient: CriminalExtractApiClientProtocol,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.apiClient = apiClient
        self.requestModel = requestModel
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.view = view
        self.viewModel = CriminalExtractResultViewModel(requestModel: requestModel)
        self.networkingContext = networkingContext
    }
    
    func configureView() {
        view.setContextMenuAvailable(isAvailable: false)
        loadInfo()
    }
    
    // MARK: - Implementation
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func didTapActionButton() {
        sendApplication()
    }
    
    func validateViewModel() {
        (viewModel?.isChecked ?? false) ? view.actionButtonDidBecomeActive() : view.actionButtonDidBecomeInactve()
    }
    
    func geContactViewModel() -> CriminalExtractResultViewModel? {
        return self.viewModel
    }
    
    // MARK: - Private Methods
    private func loadInfo() {
        self.view.setState(state: .loading)
        apiClient
            .getConfirmation(requestModel: requestModel)
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let response):
                    switch response {
                    case .data(let model):
                        self.view.setContextMenuAvailable(isAvailable: self.contextMenuProvider.hasContextMenu())
                        self.view.configureViews(vm: model)
                        self.view.setState(state: .ready)
                    case .template(let template):
                        TemplateHandler.handle(template, in: self.view) { [weak self] action in
                            if action == .skip {
                                self?.view.closeModule(animated: true)
                            }
                        }
                    }
                case .failed(let error):
                    self.handleError(error: error) { [weak self] in
                        self?.loadInfo()
                    }
                    
                default:
                    break
                }
            }
            .dispose(in: disposebag)
    }
    
    private func sendApplication() {
        view.setContextMenuAvailable(isAvailable: false)
        self.view.setLoadingState(.solidLoading, title: R.Strings.general_sending.localized())
        apiClient
            .postApplication(requestModel: requestModel)
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let response):
                    self.view.setContextMenuAvailable(isAvailable: self.contextMenuProvider.hasContextMenu())
                    self.handleData(data: response)
                case .failed(let error):
                    self.view.setLoadingState(.solid, title: R.Strings.general_send.localized())
                    self.handleError(error: error) { [weak self] in
                        self?.sendApplication()
                    }
                default:
                    break
                }
            }
            .dispose(in: disposebag)
    }
    
    private func handleData(data: CertificateApplicationResponseModel) {
        didRetry = false
        view.setState(state: .ready)
        TemplateHandler.handle(data.template, in: self.view) { [weak self] action in
            guard let self = self else { return }
            self.view.setLoadingState(.solid, title: R.Strings.general_send.localized())
            switch action {
            case .refresh:
                self.loadInfo()
            case .criminalRecordCertificate:
                guard let applicationId = data.applicationId,
                      let ratingServiceOpener = PackageConstants.ratingServiceOpener,
                      let urlOpener = PackageConstants.urlOpener else { return }
                self.flowCoordinator.replaceRoot(
                    with: CriminalExtractRequestStatusModule(
                        contextMenuItems: self.contextMenuProvider,
                        flowCoordinator: self.flowCoordinator,
                        screenType: .pendig,
                        applicationId: applicationId,
                        needToReplaceRootWithList: true,
                        сonfig: .init(ratingServiceOpener: ratingServiceOpener,
                                      networkingContext: networkingContext,
                                      urlOpener: urlOpener)
                    ),
                    animated: true
                )
            case .damagedPropertyRecoveryStatus:
                self.flowCoordinator.restartFlow()
            default:
                return
            }
        }
    }
    
    private func handleError(error: NetworkError, retryCallback: @escaping Callback) {
        GeneralErrorsHandler.process(error: .serverError, with: retryCallback, didRetry: didRetry, in: view)
        didRetry = true
    }
}
