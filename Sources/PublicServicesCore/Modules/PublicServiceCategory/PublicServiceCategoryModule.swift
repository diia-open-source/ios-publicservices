import UIKit
import DiiaMVPModule

final class PublicServiceCategoryModule: BaseModule {
    private let view: PublicServiceCategoryViewController
    private let presenter: PublicServiceCategoryPresenter
    
    init(category: PublicServiceCategoryViewModel, opener: PublicServiceOpenerProtocol) {
        view = PublicServiceCategoryViewController()
        presenter = PublicServiceCategoryPresenter(view: view, category: category, opener: opener)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
