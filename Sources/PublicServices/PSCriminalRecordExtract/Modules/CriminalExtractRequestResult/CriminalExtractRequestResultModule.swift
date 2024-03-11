import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
       
final class CriminalExtractRequestResultModule: BaseModule {
    private let view: CriminalExtractRequestResultViewController
    private let presenter: CriminalExtractRequestResultPresenter
    
    init(contextMenuItems: ContextMenuProviderProtocol,
         flowCoordinator: CriminalExtractCoordinator,
         requestModel: CriminalExtractRequestModel,
         networkingContext: PSCriminalRecordExtractNetworkingContext) {
        view = CriminalExtractRequestResultViewController()
        presenter = CriminalExtractRequestResultPresenter(
            view: view,
            contextMenuProvider: contextMenuItems,
            flowCoordinator: flowCoordinator,
            requestModel: requestModel,
            apiClient: CriminalExtractApiClient(context: networkingContext),
            networkingContext: networkingContext
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
