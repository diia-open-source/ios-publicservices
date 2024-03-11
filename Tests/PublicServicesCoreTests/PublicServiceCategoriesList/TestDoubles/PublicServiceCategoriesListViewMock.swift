import XCTest
import DiiaMVPModule
import DiiaUIComponents
@testable import DiiaPublicServicesCore

class PublicServiceCategoriesListViewMock: UIViewController, PublicServiceCategoriesListView {
    private(set) var loadingState: LoadingState?
    private(set) var isViewReloadByTab: Bool = false
    private(set) var isPublicServiceOpened: Bool = false
    private(set) var isSearchOpened: Bool = false
    private(set) var toggleTicker: Bool = false
    
    func setState(state: LoadingState) {
        loadingState = state
    }
    
    func reloadSelectedTabItems() {
        isViewReloadByTab.toggle()
    }

    func toggleTicker(show: Bool) {
        toggleTicker.toggle()
    }

    func open(module: BaseModule) {
        if module is PublicServiceSearchModule {
            isSearchOpened.toggle()
        } else {
            isPublicServiceOpened.toggle()
        }
    }
}
