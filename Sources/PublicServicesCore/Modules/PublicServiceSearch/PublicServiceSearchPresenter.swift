import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol PublicServiceSearchAction: BasePresenter {
    func setSearch(search: String?)
    func numberOfItems() -> Int
}

final class PublicServiceSearchPresenter: PublicServiceSearchAction {

	// MARK: - Properties
    unowned var view: PublicServiceSearchView

    private let publicServicesCategories: [PublicServiceSearchViewModel]
    
    private let publicServiceOpener: PublicServiceOpenerProtocol
    private var items = [DSListItemViewModel]()

    // MARK: - Init
    init(view: PublicServiceSearchView, publicServicesCategories: [PublicServiceCategoryViewModel], opener: PublicServiceOpenerProtocol) {
        self.view = view
        self.publicServicesCategories = publicServicesCategories
            .map { category in
                return category
                    .publicServices
                    .filter { $0.isActive == true }
                    .map { PublicServiceSearchViewModel(categoryName: category.name, publicService: $0) }
            }.flatMap { $0 }
        self.publicServiceOpener = opener
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.update()
        view.setupTable(items: items)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemSelected(item: PublicServiceSearchViewModel) {
        publicServiceOpener.openPublicService(type: item.publicService.type, contextMenu: item.publicService.contextMenu, in: view)

    }
    
    func setSearch(search: String?) {
        guard let search = search?.lowercased(), search.count >= Constants.minimalSearchNameCount else {
            self.items = []
            configureView()
            return
        }
            
        self.items = publicServicesCategories
            .filter { $0.publicService.search?.lowercased().contains(search) ?? false }
            .compactMap({ item in
                DSListItemViewModel(title: item.publicService.title,
                                    rightIcon: R.Image.ellipseArrowRight.image,
                                    isEnabled: true,
                                    onClick: {[weak self] in
                    self?.itemSelected(item: item)
                })
            })
        configureView()
    }
}

private extension PublicServiceSearchPresenter {
    enum Constants {
        static let minimalSearchNameCount = 3
    }
}
