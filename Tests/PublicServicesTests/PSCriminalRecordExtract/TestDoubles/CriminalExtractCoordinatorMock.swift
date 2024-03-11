import Foundation
import DiiaMVPModule
import DiiaCommonTypes
@testable import DiiaPublicServices

class CriminalExtractCoordinatorMock: CriminalExtractCoordinator {
    private(set) var isReplaceRootCalled = false
    private(set) var isOpenNextScreenCalled = false
    
    func replaceRoot(with module: BaseModule, animated: Bool) {
        isReplaceRootCalled.toggle()
    }
    
    func openNextScreen(screen: CriminalExtractScreen,
                        model: CriminalExtractRequestModel,
                        contextProvider: ContextMenuProviderProtocol,
                        networkingContext: PSCriminalRecordExtractNetworkingContext,
                        in view: BaseView) {
        isOpenNextScreenCalled.toggle()
    }
    
    func restartFlow() {}
    
    func flowWasFinishedWithSuccess(success: Bool) {}
    
    func restartFlow(with modules: [BaseModule]) {}
}
