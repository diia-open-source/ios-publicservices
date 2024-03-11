import DiiaMVPModule
import DiiaCommonTypes
@testable import DiiaPublicServicesCore

class PublicServiceRouteMock: RouterProtocol {
    private(set) var isPublicServiceOpened: Bool = false
    
    func route(in view: BaseView) {
        if view is AnyPublicServiceMockView {
            isPublicServiceOpened.toggle()
        }
    }
}
