import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

final class CriminalExtractListMockView: UIViewController, CriminalExtractListView {
    private(set) var isStubMessageConfigured = false
    private(set) var isTableViewShouldReloaded = false
    private(set) var isRequestStatusModuleCalled = false
    
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol) {
    
    }
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func setLoadingState(_ state: LoadingState) {
    }
    
    func configureStubMessage(message: AttentionMessage?) {
        isStubMessageConfigured.toggle()
    }
    
    func tableViewShouldReload() {
        isTableViewShouldReloaded.toggle()
    }
    
    func updateBackgroundColor() {
    }
    
    func open(module: BaseModule) {
        if module is CriminalExtractRequestStatusModule {
            isRequestStatusModuleCalled.toggle()
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
