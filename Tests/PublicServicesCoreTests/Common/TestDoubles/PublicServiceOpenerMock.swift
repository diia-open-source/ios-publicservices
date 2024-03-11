import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import DiiaPublicServicesCore
import UIKit

final class PublicServiceOpenerMock: PublicServiceOpenerProtocol {
    
    func canOpenPublicService(type: String) -> Bool {
        return type == "vaccinationAid" || type == "officeOfficialWorkspace"
    }
    
    func openPublicService(type: String, contextMenu: [ContextMenuItem], in view: BaseView) {
        if type == "vaccinationAid" || type == "publicService_test1" {
            view.open(module: AnyPublicServiceModuleStub())
        }
    }
    
    func openCategory(code: String, in view: BaseView) {

    }
}

final class AnyPublicServiceModuleStub: BaseModule {
    
    func viewController() -> UIViewController {
        return UIViewController()
    }
}
