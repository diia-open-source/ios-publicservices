import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractRegistrationPlaceMockView: UIViewController, CriminalExtractRegistrationPlaceView {
    
    var onListElementChange: ((Bool) -> Void)?
    var onStateChange: ((LoadingState) -> Void)?
    var onGeneralErrorShow: ((Bool) -> Void)?
    var onTemplateShow: ((Bool) -> Void)?
    var isCurrentCityHidden = false
    var isCurrentDistrictHidden = false
    var buttonState: LoadingStateButton.LoadingState = .light
    
    func setContextMenuAvailable(isAvailable: Bool) {
    }
    
    func setLoadingState(_ state: LoadingState) {
        onStateChange?(state)
    }
    
    func updateListElement(_ type: CriminalExtractAdressType, model: CriminalExtractAdressSearchModel?) {
        onListElementChange?(type == .city && model?.name.capitalized == Constants.searchText)
    }
    
    func setCurrentCityHidden(_ bool: Bool) {
        isCurrentCityHidden = bool
    }
    
    func setCurrentDistrictHidden(_ bool: Bool) {
        isCurrentDistrictHidden = bool
    }
    
    func setButtonState(_ state: LoadingStateButton.LoadingState) {
        buttonState = state
    }
    
    func configureCellText(_ type: CriminalExtractAdressType, label: String, hint: String) {
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

private extension CriminalExtractRegistrationPlaceMockView {
    enum Constants {
        static let searchText = "Київ"
    }
}
