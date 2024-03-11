import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractRequestPickerAction: BasePresenter {
    func openContextMenu()
    func didSelectItem(id: String)
	func didTapActionButton()
    func screenCode() -> String
    var requestStatePercent: Float { get }
    var requestProgressSubtitle: String? { get }
}

final class CriminalExtractRequestPickerPresenter: CriminalExtractRequestPickerAction {
    // MARK: - Private Properties
    private let apiClient: CriminalExtractApiClientProtocol
    private let contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private var items: [CriminalCertificatesRequestPickerItemModel] = []
    private var requestModel: CriminalExtractRequestModel
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let disposebag = DisposeBag()
    private var didRetry = false
    
    // MARK: - Public Properties
    unowned var view: CriminalExtractRequestPickerView
    var screenType: ExtractPickerScreenType?
    var pickerModel: CriminalCertificatesRequestPickerModel?
    
    var requestStatePercent: Float {
        guard let model = pickerModel else { return 0.0 }
        return Float(model.step) / Float(model.numberOfSteps)
    }
    
    var requestProgressSubtitle: String? {
        guard let model = pickerModel else { return nil }
        return R.Strings.criminal_certificate_request_progress_label.formattedLocalized(arguments: model.step, model.numberOfSteps)
    }
    
    // MARK: - Lifecycle
    init(
        view: CriminalExtractRequestPickerView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        screenType: ExtractPickerScreenType,
        requestModel: CriminalExtractRequestModel,
        apiClient: CriminalExtractApiClientProtocol,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.requestModel = requestModel
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.screenType = screenType
        self.view = view
        self.apiClient = apiClient
        self.networkingContext = networkingContext
    }
    
    // MARK: - Private methods
    
    private func loadInfo() {
        self.view.setState(state: .loading)
        var request: (() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError>)?
        
        switch self.screenType {
        case .intermediate:
            request = apiClient.getCertificateReasons
        case .final:
            request = apiClient.getCertificateTypes
        case .none:
            break
        }
        
        guard let request = request else {
            return
        }
        
        request()
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let response):
                    switch response {
                    case .data(let pickerModel):
                        self.view.setContextMenuAvailable(isAvailable: self.contextMenuProvider.hasContextMenu())
                        self.handlePickerData(model: pickerModel)
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
    
    private func handlePickerData(model: CertificatePickerModel?) {
        guard let pickerModel = model else {
            return
        }
        
        var pickerType: CriminalCertificateRequestPickerType?
        var step: CriminalCertificateRequestSteps?
        
        switch self.screenType {
        case .intermediate:
            pickerType = .goal
            step = .reasonPicker
        case .final:
            pickerType = .type
            step = .typePicker
        case .none:
            break
        }
        
        guard let step = step, let pickerType = pickerType else {
            return
        }
        
        switch self.screenType {
        case .intermediate:
            self.items = pickerModel.reasons?.map({ item in
                return CriminalCertificatesRequestPickerItemModel(
                    code: item.code,
                    title: item.name,
                    description: item.description
                )
                
            }) ?? []
        case .final:
            self.items = pickerModel.types?.map({ item in
                return CriminalCertificatesRequestPickerItemModel(code: item.code,
                                                                  title: item.name,
                                                                  description: item.description)
                
            }) ?? []
        case .none:
            break
        }
        
        self.pickerModel = CriminalCertificatesRequestPickerModel(type: pickerType,
                                                                  items: self.items,
                                                                  step: step.rawValue,
                                                                  numberOfSteps: 8)
        let vm = CriminalCertificatesRequestPickerViewModel(typeText: pickerModel.title,
                                                            typeSubtitle: pickerModel.subtitle,
                                                            items: self.items)
        
        self.view.configureViews(vm: vm)
        self.view.setState(state: .ready)
    }
    
    private func handleError(error: NetworkError, retryCallback: @escaping Callback) {
        GeneralErrorsHandler.process(error: .serverError, with: retryCallback, didRetry: didRetry, in: view)
        didRetry = true
    }
    
    // MARK: - Implementation
    func configureView() {
        view.setContextMenuAvailable(isAvailable: false)
        loadInfo()
    }
    
    func didTapActionButton() {
        guard let screenType = screenType else {
            return
        }
        
        switch screenType {
        case .intermediate:
            view.open(
                module: CriminalExtractRequestPickerModule(
                    screenType: .final,
                    contextMenuItems: contextMenuProvider,
                    flowCoordinator: flowCoordinator,
                    requestModel: requestModel,
                    networkingContext: networkingContext
                )
            )
        case .final:
            view.open(
                module: CriminalExtractRequesterNameModule(
                    contextMenuProvider: contextMenuProvider,
                    flowCoordinator: flowCoordinator,
                    requestModel: requestModel,
                    networkingContext: networkingContext
                )
            )
        }
    } 
    
    func didSelectItem(id: String) {
        guard pickerModel != nil else { return }
        switch screenType {
        case .intermediate:
            view.actionButtonDidBecomeActive()
            requestModel.reasonId = id
        case .final:
            view.actionButtonDidBecomeActive()
            requestModel.certificateType = id
        case .none:
            view.actionButtonDidBecomeInactve()
        }
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func screenCode() -> String {
        if screenType == .intermediate {
            return Constants.reasonsSreenCode
        }
        return Constants.certTypeSreenCode
    }
}

extension CriminalExtractRequestPickerPresenter {
    enum Constants {
        static let reasonsSreenCode = "reasonSelection"
        static let certTypeSreenCode = "certTypeSelection"
    }
}
