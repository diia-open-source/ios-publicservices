import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractContactsInputMockView: UIViewController, ContactsInputViewProtocol {
    private(set) var isSetContactsCalled = false
    private(set) var isRequestResultModuleCalled = false
    var onGeneralErrorShow: ((Bool) -> Void)?
    
    func setTitle(_ title: String?) {}
    
    func setContextMenuAvailable(isAvailable: Bool) {}
    
    func setLoadingState(state: LoadingState) {}
    
    func setSendingState(state: LoadingState, title: String?) {}
    
    func setContacts(contacts: ContactsInputModel) {
        isSetContactsCalled.toggle()
    }
    
    func open(module: BaseModule) {
        if module is CriminalExtractRequestResultModule {
            isRequestResultModuleCalled.toggle()
        }
    }
    
    func showChild(module: BaseModule) {
        if module is GeneralErrorModule {
            onGeneralErrorShow?(true)
        }
    }
}
