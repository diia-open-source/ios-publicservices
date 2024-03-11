import UIKit
import DiiaUIComponents

struct PackageConstants {
    struct Colors {
        static let tickerGrayColor = "#ECECEC"
    }
    enum PublicServiceTypeEndpoint: String {
        case officeOfficialWorkspace = "office-official-workspace"
    }
    
    // Static dependencies
    static var imageNameProvider: DSImageNameProvider?
}
