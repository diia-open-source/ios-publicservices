import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol PublicServiceCategoryAction: BasePresenter {
    func searchClick()
}

final class PublicServiceCategoryPresenter: PublicServiceCategoryAction {

	// MARK: - Properties
    unowned var view: PublicServiceCategoryView
    private let category: PublicServiceCategoryViewModel
    private var items: [PublicServiceShortViewModel] = []
    
    private var listItems: [DSListItemViewModel]?

    private let publicServiceOpener: PublicServiceOpenerProtocol

    // MARK: - Init
    init(view: PublicServiceCategoryView, category: PublicServiceCategoryViewModel, opener: PublicServiceOpenerProtocol) {
        self.view = view
        self.category = category
        self.publicServiceOpener = opener
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setSearchVisible(isVisible: category.visibleSearch && category.publicServices.count > 1)
        view.setTitle(title: category.name)
        
        self.items = category.publicServices
        
        configureTable()
    }
    
    func itemSelected(_ item: PublicServiceShortViewModel?) {
        guard let item = item else { return }
        publicServiceOpener.openPublicService(type: item.type, contextMenu: item.contextMenu, in: view)
    }
    
    func searchClick() {
        view.open(module: PublicServiceSearchModule(publicServicesCategories: [category], opener: publicServiceOpener))
    }
    
    func configureTable() {
        var list = [DSListItemViewModel]()
        for item in items {
            let listItem: DSListItemViewModel = .init(title: item.title,
                                                      rightIcon: R.Image.ellipseArrowRight.image,
                                                      isEnabled: item.isActive) { [weak self, weak item] in
                self?.itemSelected(item)
            }
            list.append(listItem)
        }
        listItems = list
        view.addList(list: .init(items: list))
    }
}

private extension PublicServiceCategoryPresenter {
    enum Constants {
        static let minimalSearchNameCount = 3
    }
}
