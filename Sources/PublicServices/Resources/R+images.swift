import UIKit

// internal because we are not ready to expose this API to outer modules yet
internal enum R {
    enum Image: String {
        case right_arrow
        case checkbox_enabled
        case checkbox_disabled
        case downloadIcon
        case eye
        case imagePlusGray
        case delete_icon_no_border
        
        var image: UIImage? {
            return UIImage(named: rawValue, in: Bundle.module, compatibleWith: nil)
        }
        
        var name: String {
            return rawValue
        }
    }
}
