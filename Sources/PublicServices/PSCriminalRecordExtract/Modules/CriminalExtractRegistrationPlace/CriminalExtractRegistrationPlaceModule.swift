import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes

final class CriminalExtractRegistrationPlaceModule: BaseModule {
    private let view: CriminalExtractRegistrationPlaceViewController
    private let presenter: CriminalExtractRegistrationPlacePresenter
    
    init(contextMenuProvider: ContextMenuProviderProtocol,
         flowCoordinator: CriminalExtractCoordinator,
         requestModel: CriminalExtractRequestModel,
         networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        view = CriminalExtractRegistrationPlaceViewController()
        presenter = CriminalExtractRegistrationPlacePresenter(
            view: view,
            contextMenuProvider: contextMenuProvider,
            flowCoordinator: flowCoordinator,
            apiClient: CriminalExtractApiClient(context: networkingContext),
            requestModel: requestModel,
            networkingContext: networkingContext
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
