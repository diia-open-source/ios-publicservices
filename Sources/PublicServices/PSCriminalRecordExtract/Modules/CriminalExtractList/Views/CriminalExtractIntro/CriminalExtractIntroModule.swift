import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes

public class CriminalExtractIntroModule: BaseModule {
    private let view: CriminalExtractIntroViewController
    private let presenter: CriminalExtractIntroPresenter
    
    public init(contextMenuItems: ContextMenuProviderProtocol,
                flowCoordinator: CriminalExtractCoordinator,
                requestModel: CriminalExtractRequestModel,
                сonfig: PSCriminalRecordExtractConfiguration) {
        view = CriminalExtractIntroViewController()
        presenter = CriminalExtractIntroPresenter(
            view: view,
            contextMenuProvider: contextMenuItems,
            flowCoordinator: flowCoordinator,
            requestModel: requestModel,
            apiClient: CriminalExtractApiClient(context: сonfig.networkingContext),
            networkingContext: сonfig.networkingContext
        )
        view.presenter = presenter
        
        PackageConstants.ratingServiceOpener = сonfig.ratingServiceOpener
        PackageConstants.urlOpener = сonfig.urlOpener
    }
    
    public func viewController() -> UIViewController {
        return view
    }
}
