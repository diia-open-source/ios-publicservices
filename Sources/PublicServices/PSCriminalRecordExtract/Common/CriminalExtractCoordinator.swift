import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaCommonServices

public protocol CriminalExtractCoordinator: FlowCoordinatorProtocol {
    func replaceRoot(with module: BaseModule, animated: Bool)
    func openNextScreen(screen: CriminalExtractScreen,
                        model: CriminalExtractRequestModel,
                        contextProvider: ContextMenuProviderProtocol,
                        networkingContext: PSCriminalRecordExtractNetworkingContext,
                        in view: BaseView)
}

public class CriminalExtractCoordinatorImpl {
    private weak var rootView: BaseView?
    public var restartCallback: Callback?
    public var successCallback: ((Bool) -> Void)?
    
    public init(rootView: BaseView?,
                restartCallback: Callback? = nil,
                successCallback: ((Bool) -> Void)? = nil) {
        self.rootView = rootView
        self.restartCallback = restartCallback
        self.successCallback = successCallback
    }
}

extension CriminalExtractCoordinatorImpl: CriminalExtractCoordinator {
    public func flowWasFinishedWithSuccess(success: Bool) {
        guard let callback = successCallback else {
            restartFlow()
            return
        }
        callback(success)
    }
    
    public func restartFlow(with modules: [BaseModule]) {
        guard let vc = rootView as? UIViewController else {
            return
        }
        vc.navigationController?.replaceViewControllers(
            with: modules.map { $0.viewController() },
            after: vc)
        restartCallback?()
    }
    
    public func restartFlow() {
        guard let rootView = rootView else { return }
        rootView.closeToRoot(animated: true)
        restartCallback?()
    }
    
    public func replaceRoot(with module: BaseModule, animated: Bool) {
        guard let vc = rootView as? UIViewController else {
            return
        }
        vc.navigationController?.replaceViewControllers(
            with: [
                module.viewController()
            ],
            after: vc,
            includingReference: true,
            animated: animated
        )
        rootView = module.viewController() as? BaseView
    }
    
    public func openNextScreen(screen: CriminalExtractScreen,
                               model: CriminalExtractRequestModel,
                               contextProvider: ContextMenuProviderProtocol,
                               networkingContext: PSCriminalRecordExtractNetworkingContext,
                               in view: BaseView) {
        
        switch screen {
        case .birthPlace:
            view.open(
                module: CriminalExtractBirthPlaceModule(
                    contextMenuProvider: contextProvider,
                    flowCoordinator: self,
                    requestModel: model,
                    networkingContext: networkingContext
                )
            )
        case .nationalities:
            view.open(module: CriminalExtractNationalitiesModule(
                contextMenuProvider: contextProvider,
                flowCoordinator: self,
                requestModel: model,
                networkingContext: networkingContext
            ))
        case .registrationPlace:
            view.open(
                module: CriminalExtractRegistrationPlaceModule(
                    contextMenuProvider: contextProvider,
                    flowCoordinator: self,
                    requestModel: model,
                    networkingContext: networkingContext
                )
            )
        case .contacts:
            view.open(
                module: ContactsInputModule(
                    contextMenuProvider: contextProvider,
                    contactsHandler: CriminalExtractContactHandler(
                        contextMenuProvider: contextProvider,
                        apiService: CriminalExtractApiClient(context: networkingContext),
                        flowCoordinator: self,
                        requestModel: model,
                        networkingContext: networkingContext
                    ),
                    urlOpener: PackageConstants.urlOpener
                )
            )
        }
    }
}
