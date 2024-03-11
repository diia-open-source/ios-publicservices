import Foundation
import DiiaMVPModule
import DiiaCommonTypes

public protocol PublicServiceOpenerProtocol {
    /**
    Main method that starts opening specific Public service in response of user's choice .
    - parameter type - string for identifying which Module must be created
    - parameter contextMenu - items for generating ContextMenuProvider, may be backend provided
    - parameter view - view show show new module on
    */
    func openPublicService(type: String, contextMenu: [ContextMenuItem], in view: BaseView)
    func canOpenPublicService(type: String) -> Bool
    func openCategory(code: String, in view: BaseView)
}
