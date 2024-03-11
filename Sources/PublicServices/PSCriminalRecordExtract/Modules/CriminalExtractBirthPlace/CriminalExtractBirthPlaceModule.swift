import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaNetwork

final class CriminalExtractBirthPlaceModule: BaseModule {
    private let view: CriminalExtractBirthPlaceViewController
    private let presenter: CriminalExtractBirthPlacePresenter
    
    init(
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        view = CriminalExtractBirthPlaceViewController()
        presenter = CriminalExtractBirthPlacePresenter(
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
