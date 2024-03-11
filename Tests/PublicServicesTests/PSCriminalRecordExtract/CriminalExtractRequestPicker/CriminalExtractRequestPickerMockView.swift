import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractRequestPickerMockView: UIViewController, CriminalExtractRequestPickerView {
    private(set) var isRequestPickerModuleCalled = false
    private(set) var isRequesterNameModuleCalled = false
    
    var onTemplateShow: ((Bool) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onStateChange: ((LoadingState) -> Void)?
    var viewModel = CriminalCertificatesRequestPickerViewModel(
        typeText: "",
        typeSubtitle: "",
        items: []
    )
    var isActionButtonActive = false
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func actionButtonDidBecomeActive() {
        isActionButtonActive = true
    }
    
    func actionButtonDidBecomeInactve() {
    }
    
    func setState(state: LoadingState) {
        onStateChange?(state)
    }
    
    func configureViews(vm: CriminalCertificatesRequestPickerViewModel) {
        self.viewModel = vm
    }
    
    func open(module: BaseModule) {
        if module is CriminalExtractRequestPickerModule {
            isRequestPickerModuleCalled.toggle()
        } else if module is CriminalExtractRequesterNameModule {
            isRequesterNameModuleCalled.toggle()
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
