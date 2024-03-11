import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractIntroAction: BasePresenter {
    func didTapActionButton()
    func openContextMenu()
    func configureView()
}

final class CriminalExtractIntroPresenter: CriminalExtractIntroAction {
    
    // MARK: - private properties
    private let apiClient: CriminalExtractApiClientProtocol
    private let contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private var requestModel: CriminalExtractRequestModel
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private var didRetry = false
    private let disposebag = DisposeBag()
    
    private var isAvailableContextMenu: Bool {
        return contextMenuProvider.hasContextMenu()
    }
    
    private var response: CertificateIntroModel?
    
    // MARK: - Public properties
    unowned var view: CriminalExtractIntroView

    // MARK: - Initialization
    init(
        view: CriminalExtractIntroView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        apiClient: CriminalExtractApiClientProtocol,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.requestModel = requestModel
        self.contextMenuProvider = contextMenuProvider
        self.view = view
        self.apiClient = apiClient
        self.flowCoordinator = flowCoordinator
        self.networkingContext = networkingContext
    }
    
    func configureView() {
        view.setContextMenuAvailable(isAvailable: false)
        loadInfo()
    }
    
    // MARK: - Private Methods
    private func loadInfo() {
        self.view.setLoadingState(.loading)
        apiClient
            .getIntro(publicService: requestModel.publicService?.code)
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let response):
                    self.didRetry = false
                    self.handleResponse(response: response)
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
    
    private func handleResponse(response: TemplatedResponse<CertificateIntroModel>) {
        switch response {
        case .data(let data):
            if let showContext = data.showContextMenu,
               showContext {
                self.view.setContextMenuAvailable(isAvailable: self.contextMenuProvider.hasContextMenu())
            }
            self.response = data
            self.view.configureStartScreen(model: data)
            self.view.setLoadingState(.ready)
        case .template(let template):
            TemplateHandler.handle(template, in: self.view) { [weak self] action in
                if action == .skip {
                    self?.view.closeModule(animated: true)
                }
            }
        }
    }
    
    private func handleError(error: NetworkError, retryCallback: @escaping Callback) {
        GeneralErrorsHandler.process(error: .serverError, with: retryCallback, didRetry: didRetry, in: view)
        didRetry = true
    }
    
    // MARK: - Implementation
    func didTapActionButton() {
        if response?.nextScreen == .requester {
            view.open(
                module: CriminalExtractRequesterNameModule(
                    contextMenuProvider: contextMenuProvider,
                    flowCoordinator: flowCoordinator,
                    requestModel: requestModel,
                    networkingContext: networkingContext
                )
            )
            return
        }
        self.view.open(
            module: CriminalExtractRequestPickerModule(
                screenType: .intermediate,
                contextMenuItems: contextMenuProvider,
                flowCoordinator: flowCoordinator,
                requestModel: requestModel,
                networkingContext: networkingContext
            )
        )
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
}
