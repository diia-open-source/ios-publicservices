import UIKit
import DiiaMVPModule
import DiiaCommonServices
import DiiaUIComponents
import DiiaCommonTypes
@testable import DiiaPublicServices

class CriminalExtractIntroMockView: UIViewController, CriminalExtractIntroView {
    var state: LoadingState = .loading
    var model = CertificateIntroModel(
        showContextMenu: nil,
        title: nil,
        text: nil,
        attentionMessage: nil,
        nextScreen: nil
    )
    private(set) var isContextMenuAvalable = false
    private(set) var isRequestPickerModuleCalled = false
    private(set) var isRequesterNameModuleCalled = false
    
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    
    func setContextMenuAvailable(isAvailable: Bool) {
        self.isContextMenuAvalable = isAvailable
    }
    
    func setLoadingState(_ state: LoadingState) {
        self.state = state
    }
    
    func configureStartScreen(model: CertificateIntroModel) {
        self.model = model
    }
    
    func addAlertView(message: AttentionMessage) {
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
