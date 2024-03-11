import Foundation
import DiiaMVPModule
import DiiaCommonTypes

class ContextMenuProviderMock: ContextMenuProviderProtocol {
    var hasContextMenuReturnValue: Bool = false
    var viewPassedInOpenContextMenu: BaseView?
    var itemsPassedInSetContextMenu: [ContextMenuItem]?
    var titleAssignedInSetTitle: String?
    var titleToReturn: String?

    func hasContextMenu() -> Bool {
        return hasContextMenuReturnValue
    }

    func openContextMenu(in view: BaseView) {
        viewPassedInOpenContextMenu = view
    }

    func setContextMenu(items: [ContextMenuItem]?) {
        itemsPassedInSetContextMenu = items
    }

    func setTitle(title: String?) {
        titleAssignedInSetTitle = title
    }

    var title: String? {
        get {
            return titleToReturn
        }
        set {
            titleToReturn = newValue
        }
    }
}
