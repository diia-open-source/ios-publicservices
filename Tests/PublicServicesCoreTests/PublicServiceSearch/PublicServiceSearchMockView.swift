import XCTest
import DiiaMVPModule
import DiiaUIComponents
@testable import DiiaPublicServicesCore

class PublicServiceSearchMockView: UIViewController, PublicServiceSearchView {
    
    private(set) var isViewUpdateCalled: Bool = false
    private(set) var isTableConfigured: Bool = false
    private(set) var isPublicServiceOpened: Bool = false
    
    func update() {
        isViewUpdateCalled = true
    }
    
    func setupTable(items: [DSListItemViewModel]) {
        isTableConfigured.toggle()
    }
    
    func open(module: BaseModule) {
        if module is AnyPublicServiceModuleStub {
            isPublicServiceOpened.toggle()
        }
    }
}
