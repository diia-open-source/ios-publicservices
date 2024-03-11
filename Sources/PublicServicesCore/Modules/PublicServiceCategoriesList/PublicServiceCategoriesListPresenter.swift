import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaUIComponents
import DiiaCommonServices

class PublicServiceCategoriesModel {
    var allItems: [PublicServiceCategoryViewModel]
    var visibleItems: [PublicServiceCategoryViewModel]
    var currentTab: PublicServiceTabType?
    var publicServiceTabsViewModel: TabSwitcherViewModel
    let publicServiceOpener: PublicServiceOpenerProtocol
    
    init(allItems: [PublicServiceCategoryViewModel] = [],
         visibleItems: [PublicServiceCategoryViewModel] = [],
         currentTab: PublicServiceTabType? = nil,
         publicServiceTabsViewModel: TabSwitcherViewModel = .init(),
         publicServiceOpener: PublicServiceOpenerProtocol) {
        self.allItems = allItems
        self.visibleItems = visibleItems
        self.currentTab = currentTab
        self.publicServiceTabsViewModel = publicServiceTabsViewModel
        self.publicServiceOpener = publicServiceOpener
    }
}

protocol PublicServiceCategoriesListAction: BasePresenter {
    func numberOfItems() -> Int
    func itemAt(index: Int) -> PublicServiceCategoryViewModel?
    func itemSelected(index: Int)
    func updateServices()
    func checkReachability()
    func searchClick()
    func getTabsViewModel() -> TabSwitcherViewModel
}

final class PublicServiceCategoriesListPresenter: PublicServiceCategoriesListAction {
    
    // MARK: - Properties
    unowned var view: PublicServiceCategoriesListView
    private let storage: PublicServicesStorage?
    private let apiClient: PublicServicesAPIClientProtocol
    private var model: PublicServiceCategoriesModel
    private let bag = DisposeBag()
    
    // MARK: - Init
    init(view: PublicServiceCategoriesListView,
         apiClient: PublicServicesAPIClientProtocol,
         model: PublicServiceCategoriesModel,
         storage: PublicServicesStorage?) {
        self.view = view
        self.apiClient = apiClient
        self.model = model
        self.storage = storage

    }
    
    func configureView() {
        ReachabilityHelper.shared
            .statusSignal
            .observeNext { [weak self] isReachable in
                self?.onNetworkStatus(isReachable: isReachable)
            }
            .dispose(in: bag)
    }

    private func onNetworkStatus(isReachable: Bool) {
        if isReachable && numberOfItems() == 0 {
            updateServices()
        }
    }

    // MARK: - PublicServiceCategoriesListAction
    func numberOfItems() -> Int {
        return model.visibleItems.count
    }
    
    func itemAt(index: Int) -> PublicServiceCategoryViewModel? {
        if index >= 0 && index < model.visibleItems.count {
            return model.visibleItems[index]
        }
        return nil
    }
    
    func itemSelected(index: Int) {
        guard
            model.visibleItems.indices.contains(index)
        else {
            return
        }
        
        let item = model.visibleItems[index]
        if item.status != .active { return }
        
        if item.publicServices.count == 1, item.publicServices[0].isActive {
            model.publicServiceOpener.openPublicService(type: item.publicServices[0].type, contextMenu: item.publicServices[0].contextMenu, in: view)
        } else {
            view.open(module: PublicServiceCategoryModule(category: item, opener: model.publicServiceOpener))
        }
    }
    
    func updateServices() {
        let isFirstLoading = model.allItems.isEmpty
        
        if isFirstLoading {
            view.setState(state: .loading)
        }
        
        apiClient
            .getPublicServices()
            .observe { [weak self] (event) in
                switch event {
                case .next(let response):
                    self?.storage?.savePublicServicesResponse(response: response)
                    self?.processResponse(response: response)
                case .failed(let error):
                    if let cachedResponse = self?.storage?.getPublicServicesResponse() {
                        self?.processResponse(response: cachedResponse)
                    } else {
                        self?.showNoInternetTemplate(error)
                    }
                default:
                    return
                }
                
                if isFirstLoading {
                    self?.view.setState(state: .ready)
                }
            }
            .dispose(in: bag)
    }

    func checkReachability() {
        onNetworkStatus(isReachable: ReachabilityHelper.shared.isReachable())
    }

    private func processResponse(response: PublicServiceResponse) {
        let validatorTask: PublicServiceCodeValidator = { code in
            self.model.publicServiceOpener.canOpenPublicService(type: code)
        }

        model.allItems = response
            .publicServicesCategories
            .map { PublicServiceCategoryViewModel(model: $0, typeValidator: validatorTask) }
            .filter {
                $0.publicServices.count > 1
                || ($0.publicServices.count == 1
                    && $0.publicServices[0].isActive) }
        configureTabs(from: response.tabs)
    }

    private func showNoInternetTemplate(_ error: NetworkError) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: { [weak self] in
                self?.updateServices()
            },
            didRetry: false,
            in: view)
    }

    func searchClick() {
        view.open(module: PublicServiceSearchModule(publicServicesCategories: model.allItems, opener: model.publicServiceOpener))
    }
    
    func getTabsViewModel() -> TabSwitcherViewModel {
        return model.publicServiceTabsViewModel
    }
    
    // MARK: - Private Methods
    private func configureTabs(from responseTabs: [PublicServiceTab]) {
        let items = responseTabs.compactMap { TabSwitcherModel(id: $0.code.rawValue, title: $0.name) }
        if items.count == .zero {
            model.visibleItems = model.allItems
            return
        }
        model.publicServiceTabsViewModel = .init(items: items)
        model.publicServiceTabsViewModel.action = { [weak self] tabIndex in
            guard let self = self else { return }
            self.handleItems(by: PublicServiceTabType(rawValue: self.model.publicServiceTabsViewModel.items[tabIndex].id) ?? .defaultValue)
            self.view.reloadSelectedTabItems()
        }
        
        if let currentTab = model.currentTab, responseTabs.first(where: { $0.code == currentTab }) != nil {
            handleItems(by: currentTab)
            return
        }
        handleItems(by: .defaultValue)
    }
    
    private func handleItems(by tabType: PublicServiceTabType) {
        model.publicServiceTabsViewModel.items.forEach {
            $0.isSelected = $0.id == tabType.rawValue
        }
        model.currentTab = tabType
        model.visibleItems = model.allItems.filter { $0.tabCodes.contains(tabType) }
    }
}
