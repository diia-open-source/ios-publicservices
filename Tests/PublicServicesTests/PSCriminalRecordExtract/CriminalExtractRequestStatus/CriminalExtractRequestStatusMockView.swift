import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractRequestStatusMockView: UIViewController, CriminalExtractRequestStatusView {
    
    private(set) var isCloseModuleCalled = false
    var onTemplateShow: ((Bool) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onStateChange: ((LoadingState) -> Void)?
    var onFilePreviewDidCall: ((URL) -> Void)?
    var onFileDownloadDidCall: ((URL) -> Void)?
    var configureScreenDidCall = false
    
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol) {}
    
    func setContextMenuAvailable(isAvailable: Bool) {}
    
    func configureScreen(vm: CriminalExtractStatusModel) {
        configureScreenDidCall = true
    }
    
    func setState(state: LoadingState) {
        onStateChange?(state)
    }
    
    func downloadDocument(by path: URL) {
        onFileDownloadDidCall?(path)
    }
    
    func previewFile(by path: URL) {
        onFilePreviewDidCall?(path)
    }
    
    func updateDownloadViewModelState(isLoading: Bool) {}
    
    func updatePreviewViewModelState(isLoading: Bool) {}
    
    func showChild(module: BaseModule) {
        if module is GeneralErrorModule {
            onGeneralErrorShow?(true)
        } else if let childContainerController = module.viewController() as? ChildContainerViewController,
                  let _ = childContainerController.childSubview as? SmallAlertViewController {
            onTemplateShow?(true)
        }
    }
    
    func closeModule(animated: Bool) {
        isCloseModuleCalled.toggle()
    }
}
