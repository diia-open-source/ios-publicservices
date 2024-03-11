import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractNationalitiesMockView: UIViewController, CriminalExtractNationalitiesView {
    
    var onStateChange: ((LoadingState) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func setLoadingState(_ state: LoadingState) {
        onStateChange?(state)
    }
    
    func updateTableView() {
    }
    
    func setActionButtonActive(_ bool: Bool) {
    }
    
    func open(module: BaseModule) {
        guard let searchView = module.viewController() as? BaseSearchViewController else { return }
        searchView.loadViewIfNeeded()
        searchView.presenter.setSearchText(text: Constants.searchText)
        searchView.presenter.selectItem(index: 0)
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

private extension CriminalExtractNationalitiesMockView {
    enum Constants {
        static let searchText = "Австрія"
    }
}
