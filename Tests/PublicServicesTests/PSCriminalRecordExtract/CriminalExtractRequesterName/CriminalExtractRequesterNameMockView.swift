import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractRequesterNameMockView: UIViewController, CriminalCertificateRequesterNameView {
    
    var onStateChange: ((LoadingState) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    private (set) var updatedTableViewRowIndex = 0
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func setLoadingState(_ state: LoadingState) {
        onStateChange?(state)
    }
    
    func setActionButtonActive(_ bool: Bool) {
    }
    
    func updateTableView(row: Int) {
        updatedTableViewRowIndex = row
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
