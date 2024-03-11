import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractRequestResultMockView: UIViewController, CriminalExtractRequestResultView {
    
    var isActionButtonActive = false
    var onStateChange: ((LoadingState) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var configureViewsDidCall = false
    var onLoadingState: ((LoadingStateButton.LoadingState) -> Void)?
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func actionButtonDidBecomeActive() {
        isActionButtonActive = true
    }
    
    func actionButtonDidBecomeInactve() {
        isActionButtonActive = false
    }
    
    func setState(state: LoadingState) {
        onStateChange?(state)
    }
    
    func configureViews(vm: CriminalExtractNewConfirmationModel) {
        configureViewsDidCall = true
    }
    
    func setLoadingState(_ state: LoadingStateButton.LoadingState, title: String) {
        onLoadingState?(state)
    }
    
    func showChild(module: BaseModule) {
        if module is GeneralErrorModule {
            onGeneralErrorShow?(true)
        } else if let childContainerController = module.viewController() as? ChildContainerViewController,
                  let controller = childContainerController.childSubview as? SmallAlertViewController {
            controller.presenter.onMainButton()
        }
    }
}
