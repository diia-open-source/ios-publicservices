import Foundation

internal extension R {
    enum Strings: String {
        case public_services_search
        case public_services_search_placeholder
        case public_services_search_empty
        case services_unavailable
        case services_list_title
        
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return String(format: localized, arguments)
        }
    }
}
