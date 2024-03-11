import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
       
public class CriminalExtractRequestStatusModule: BaseModule {
    private let view: CriminalExtractRequestStatusViewController
    private let presenter: CriminalExtractRequestStatusPresenter
    
    public init(contextMenuItems: ContextMenuProviderProtocol,
                flowCoordinator: CriminalExtractCoordinator,
                screenType: CriminalCertStatusScreenType,
                applicationId: String,
                certificateDate: String? = nil,
                needToReplaceRootWithList: Bool = false,
                сonfig: PSCriminalRecordExtractConfiguration) {
        view = CriminalExtractRequestStatusViewController()
        presenter = CriminalExtractRequestStatusPresenter(view: view,
                                                          contextMenuProvider: contextMenuItems,
                                                          flowCoordinator: flowCoordinator,
                                                          screenType: screenType,
                                                          apiClient: CriminalExtractApiClient(context: сonfig.networkingContext),
                                                          applicationId: applicationId,
                                                          documentDate: certificateDate,
                                                          needToReplaceRootWithList: needToReplaceRootWithList,
                                                          networkingContext: сonfig.networkingContext)
        
        view.screenState = screenType
        if let certificateDate = certificateDate {
            presenter.date = certificateDate
                .replacingOccurrences(of: R.Strings.certificate_name_from_ukr.localized(), with: R.Strings.certificate_name_from_translit.localized())
                .replacingOccurrences(of: R.Strings.certificate_name_from_dot.localized(), with: R.Strings.certificate_name_from_dash.localized())
        }
        view.presenter = presenter
        
        PackageConstants.ratingServiceOpener = сonfig.ratingServiceOpener
        PackageConstants.urlOpener = сonfig.urlOpener
    }

    public func viewController() -> UIViewController {
        return view
    }
}
