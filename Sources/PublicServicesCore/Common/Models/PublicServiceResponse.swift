import Foundation
import DiiaUIComponents
import DiiaCommonTypes

public struct PublicServiceResponse: Codable {
    let publicServicesCategories: [PublicServiceCategory]
    let tabs: [PublicServiceTab]
}

public struct PublicServiceCategory: Codable {
    let code: String
    let icon: String
    let name: String
    let status: PublicServiceStatus
    let visibleSearch: Bool
    let tabCodes: [PublicServiceTabType]
    let publicServices: [PublicServiceModel]
}

public struct PublicServiceModel: Codable {
    let status: PublicServiceStatus
    let name: String
    let code: String? // ex-PublicServiceType
    let badgeNumber: Int?
    let search: String?
    let contextMenu: [ContextMenuItem]?
}

public enum PublicServiceStatus: String, Codable, EnumDecodable {
    public static let defaultValue: PublicServiceStatus = .inactive

    case inactive
    case active
}

public struct PublicServiceTab: Codable {
    let name: String
    let code: PublicServiceTabType
}

public enum PublicServiceTabType: String, Codable, EnumDecodable {
    public static let defaultValue: PublicServiceTabType = .citizen

    case citizen
    case office
}
