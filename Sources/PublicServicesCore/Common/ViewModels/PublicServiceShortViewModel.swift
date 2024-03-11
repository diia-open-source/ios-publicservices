import Foundation
import DiiaCommonTypes

/**
The task for validation public service type
- parameter code - string value for identifying public service type.
- returns validation result. True if public service type code is allowed by app, otherwise - false
*/
typealias PublicServiceCodeValidator = (_ code: String) -> Bool

class PublicServiceShortViewModel: NSObject {
    let title: String
    let isActive: Bool
    let type: String // ex-PublicServiceType
    let search: String?
    let contextMenu: [ContextMenuItem]
    let inBetaMode: Bool
    @objc dynamic var counter: Int
    
    init(model: PublicServiceModel, validator: PublicServiceCodeValidator) {
        self.title = model.name
        self.counter = model.badgeNumber ?? 0
        let type = model.code ?? "unknown"
        self.type = type
        let isValidType = validator(type)
        self.search = model.search
        self.isActive = type != "unknown" && isValidType && model.status == .active
        self.inBetaMode = false
        self.contextMenu = model.contextMenu ?? []
    }
}
