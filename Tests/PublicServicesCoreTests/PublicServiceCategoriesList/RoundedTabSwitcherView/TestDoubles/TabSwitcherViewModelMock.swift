import XCTest
import DiiaUIComponents
@testable import DiiaPublicServicesCore

class TabSwitcherViewModelMock: TabSwitcherViewModel {
    private(set) var isTabSelected = false
    
    override func itemAt(index: Int) -> TabSwitcherModel? {
        return items[index]
    }
    
    override func itemSelected(index: Int) {
        if items.indices.contains(index) { isTabSelected.toggle() }
    }
}
