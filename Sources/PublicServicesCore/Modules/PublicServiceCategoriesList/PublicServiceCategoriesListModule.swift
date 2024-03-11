import UIKit
import DiiaMVPModule
import DiiaUIComponents

public final class PublicServiceCategoriesListModule: BaseModule {
    private let view: PublicServiceCategoriesListViewController
    private let presenter: PublicServiceCategoriesListPresenter

    public init(context: PublicServicesCoreContext) {
        view = PublicServiceCategoriesListViewController.storyboardInstantiate(bundle: Bundle.module)

        let apiClient = PublicServicesAPIClient(context: context.network)
        let publicServiceOpener = PublicServiceOpener(apiClient: apiClient, routeManager: context.publicServiceRouteManager)
        let model = PublicServiceCategoriesModel(publicServiceOpener: publicServiceOpener)
        self.presenter = PublicServiceCategoriesListPresenter(view: view,
                                                              apiClient: apiClient,
                                                              model: model,
                                                              storage: context.storeHelper)

        view.presenter = presenter
        PackageConstants.imageNameProvider = context.imageNameProvider
    }

    public func viewController() -> UIViewController {
        return view
    }
}
