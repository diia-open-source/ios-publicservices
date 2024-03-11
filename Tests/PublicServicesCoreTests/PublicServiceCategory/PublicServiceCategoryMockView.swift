import XCTest
import DiiaMVPModule
import DiiaUIComponents
@testable import DiiaPublicServicesCore

class PublicServiceCategoryMockView: UIViewController, PublicServiceCategoryView {
    
    private(set) var isTitleConfigured: Bool = false
    private(set) var isSearchVisible: Bool = false
    private(set) var isListAdded: Bool = false
    private(set) var isPublicServiceOpened: Bool = false
    private(set) var isSearchOpened: Bool = false
    
    func setTitle(title: String) {
        isTitleConfigured.toggle()
    }
    
    func setSearchVisible(isVisible: Bool) {
        isSearchVisible = isVisible
    }
    
    func addList(list: DSListViewModel) {
        isListAdded.toggle()
    }
    
    func open(module: BaseModule) {
        if module is AnyPublicServiceModuleStub {
            isPublicServiceOpened.toggle()
        } else if module is PublicServiceSearchModule {
            isSearchOpened.toggle()
        }
    }
}
