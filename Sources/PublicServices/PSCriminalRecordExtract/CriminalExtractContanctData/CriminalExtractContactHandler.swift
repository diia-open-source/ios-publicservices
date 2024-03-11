import Foundation
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

final class CriminalExtractContactHandler: NSObject {
    
    private let contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let apiService: CriminalExtractApiClientProtocol
    private var requestModel: CriminalExtractRequestModel
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private var didRetry = false
    
    init(
        contextMenuProvider: ContextMenuProviderProtocol,
        apiService: CriminalExtractApiClientProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.contextMenuProvider = contextMenuProvider
        self.apiService = apiService
        self.flowCoordinator = flowCoordinator
        self.requestModel = requestModel
        self.networkingContext = networkingContext
    }
    
    private func handleError(
        error: NetworkError,
        view: BaseView,
        retryAction: @escaping Callback
    ) {
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

extension CriminalExtractContactHandler: ContactsInputHandler {
    
    func title() -> String {
        return R.Strings.criminal_extract_title.localized()
    }
    
    func buttonTitle() -> String? {
        return R.Strings.general_next.localized()
    }
    
    func fetchContactsInputInfo(in view: ContactsInputViewProtocol) {
        apiService
            .getContacts()
            .observe { [weak self, weak view] response in
                guard let self = self, let view = view else { return }
                switch response {
                case .next(let data):
                    view.setContacts(
                        contacts: ContactsInputModel(
                            navigationPanel: nil,
                            title: data.title,
                            description: data.text,
                            text: nil,
                            phoneNumber: data.phoneNumber,
                            phone: nil,
                            email: nil,
                            attentionMessage: nil
                        )
                    )
                    view.setLoadingState(state: .ready)
                case .failed(let error):
                    self.handleError(
                        error: error,
                        view: view,
                        retryAction: { [weak self, weak view] in
                            guard let self = self, let view = view else { return }
                            self.fetchContactsInputInfo(in: view)
                        }
                    )
                default:
                    break
                }
            }
            .dispose(in: bag)
    }
    
    func sendContacts(contacts: [ContactInputType: String], in view: ContactsInputViewProtocol) {
        self.requestModel.phoneNumber = contacts[.phone]
        view.open(
            module: CriminalExtractRequestResultModule(
                contextMenuItems: contextMenuProvider,
                flowCoordinator: flowCoordinator,
                requestModel: requestModel,
                networkingContext: networkingContext
            )
        )
    }
    
    func availableContactTypes() -> Set<ContactInputType> {
        return [.phone]
    }
}
