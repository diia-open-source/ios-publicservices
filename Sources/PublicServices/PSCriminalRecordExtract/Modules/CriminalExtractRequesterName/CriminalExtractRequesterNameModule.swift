import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaUIComponents
import DiiaCommonTypes

final class CriminalExtractRequesterNameModule: BaseModule {
    private let view: CriminalExtractRequesterNameViewController
    private let presenter: CriminalExtractRequesterNamePresenter
    
    init(
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        view = CriminalExtractRequesterNameViewController()
        presenter = CriminalExtractRequesterNamePresenter(
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
