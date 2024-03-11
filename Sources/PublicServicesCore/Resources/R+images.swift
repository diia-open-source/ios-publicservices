import UIKit

internal enum R {
    enum Image: String {
        case forward
        case search_light
        case ellipseArrowRight
        case light_background
         
        var image: UIImage? {
            return UIImage(named: rawValue, in: Bundle.module, compatibleWith: nil)
        }
        
        var name: String {
            return rawValue
        }
    }
}
