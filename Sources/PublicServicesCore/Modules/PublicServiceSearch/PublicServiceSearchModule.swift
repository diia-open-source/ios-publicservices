import UIKit
import DiiaMVPModule

final class PublicServiceSearchModule: BaseModule {
    private let view: PublicServiceSearchViewController
    private let presenter: PublicServiceSearchPresenter
    
    init(publicServicesCategories: [PublicServiceCategoryViewModel], opener: PublicServiceOpenerProtocol) {
        view = PublicServiceSearchViewController()
        presenter = PublicServiceSearchPresenter(view: view, publicServicesCategories: publicServicesCategories, opener: opener)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
