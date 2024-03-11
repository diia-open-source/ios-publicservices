import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes

final class CriminalExtractNationalitiesModule: BaseModule {
    private let view: CriminalExtractNationalitiesViewController
    private let presenter: CriminalExtractNationalitiesPresenter
    
    init(
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        view = CriminalExtractNationalitiesViewController()
        presenter = CriminalExtractNationalitiesPresenter(
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
