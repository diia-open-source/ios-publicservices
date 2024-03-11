import UIKit
import DiiaMVPModule
@testable import DiiaPublicServicesCore

class AnyPublicServiceMockView: UIViewController, BaseView {
    private(set) var isPublicServiceCategoryOpened: Bool = false
    
    func open(module: BaseModule) {
        if module is PublicServiceCategoryModule {
            isPublicServiceCategoryOpened.toggle()
        }
    }
}
