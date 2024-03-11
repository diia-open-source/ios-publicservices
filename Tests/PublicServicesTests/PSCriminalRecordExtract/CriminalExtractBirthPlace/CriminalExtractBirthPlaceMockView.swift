import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractBirthPlaceMockView: UIViewController, CriminalExtractBirthPlaceView {
    
    private(set) var updatedSectionIndex: Int?
    private(set) var isBaseSearchModuleCalled = false
    
    var onStateChange: ((LoadingState) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func setLoadingState(_ state: LoadingState) {
        onStateChange?(state)
    }
    
    func updateSection(index: Int) {
        updatedSectionIndex = index
    }
    
    func setActionButtonActive(_ bool: Bool) {
    }
    
    func open(module: BaseModule) {
        if module is BaseSearchModule {
            isBaseSearchModuleCalled.toggle()
        }
    }
    
    func showChild(module: BaseModule) {
        if module is GeneralErrorModule {
            onGeneralErrorShow?(true)
        } else if let childContainerController = module.viewController() as? ChildContainerViewController,
                  let _ = childContainerController.childSubview as? SmallAlertViewController {
            onTemplateShow?(true)
        }
    }
}
