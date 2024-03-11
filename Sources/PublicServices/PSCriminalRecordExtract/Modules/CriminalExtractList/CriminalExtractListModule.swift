import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public class CriminalExtractListModule: BaseModule {
    private let view: CriminalExtractListViewController
    private let presenter: CriminalExtractListPresenter
    
    public init(contextMenuProvider: ContextMenuProviderProtocol,
                flowCoordinator: CriminalExtractCoordinator? = nil,
                preselectedType: CertificateStatus = .done,
                сonfig: PSCriminalRecordExtractConfiguration) {
        view = CriminalExtractListViewController()
        let coordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        presenter = CriminalExtractListPresenter(
            view: view,
            contextMenuProvider: contextMenuProvider,
            flowCoordinator: coordinator,
            preselectedType: preselectedType,
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
