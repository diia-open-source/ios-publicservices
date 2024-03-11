import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
       
final class CriminalExtractRequestPickerModule: BaseModule {
    private let view: CriminalExtractRequestPickerViewController
    private let presenter: CriminalExtractRequestPickerPresenter
    
    init(screenType: ExtractPickerScreenType,
         contextMenuItems: ContextMenuProviderProtocol,
         flowCoordinator: CriminalExtractCoordinator,
         requestModel: CriminalExtractRequestModel,
         networkingContext: PSCriminalRecordExtractNetworkingContext) {
        view = CriminalExtractRequestPickerViewController()
        presenter = CriminalExtractRequestPickerPresenter(
            view: view,
            contextMenuProvider: contextMenuItems,
            flowCoordinator: flowCoordinator,
            screenType: screenType,
            requestModel: requestModel,
            apiClient: CriminalExtractApiClient(context: networkingContext),
            networkingContext: networkingContext
        )
        presenter.screenType = screenType
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
