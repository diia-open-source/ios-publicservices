import Foundation
@testable import DiiaPublicServicesCore

struct PublicServiceCategoryStub {
    static let responseData = PublicServiceCategory(code: "category",
                                                    icon: "",
                                                    name: "category_test",
                                                    status: .active,
                                                    visibleSearch: true,
                                                    tabCodes: [.citizen],
                                                    publicServices: [.init(status: .active,
                                                                           name: "publicService_test1",
                                                                           code: "publicService_test1",
                                                                           badgeNumber: nil,
                                                                           search: "publicService_test1",
                                                                           contextMenu: nil),
                                                                     .init(status: .active,
                                                                           name: "publicService_test2",
                                                                           code: "publicService_test2",
                                                                           badgeNumber: nil,
                                                                           search: "publicServices_test2",
                                                                           contextMenu: nil)])
    
    static let publicServiceValidatorTask: PublicServiceCodeValidator = { code in
        return code == "publicService_test1" || code == "publicService_test2"
    }
}
