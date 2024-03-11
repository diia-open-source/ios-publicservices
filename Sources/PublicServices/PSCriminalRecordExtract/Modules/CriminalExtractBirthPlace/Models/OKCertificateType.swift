import Foundation

public enum OKCertificateType: String {
    case ok5
    case ok7
    
    public var apiPath: String {
        switch self {
        case .ok5:
            return "ok5-cert"
        case .ok7:
            return "ok7-cert"
        }
    }
    
    public var listApiPath: String {
        switch self {
        case .ok5:
            return "ok5-cert/list"
        case .ok7:
            return "ok7-cert/list"
        }
    }
    
    public var screenTitle: String {
        switch self {
        case .ok7:
            return R.Strings.criminal_certificate_request_home_title_ok7.localized()
        case .ok5:
            return R.Strings.criminal_certificate_request_home_title_ok5.localized()
        }
    }
    
    public var cardTitle: String {
        switch self {
        case .ok7:
            return R.Strings.criminal_certificate_request_home_title_ok7.localized()
        case .ok5:
            return R.Strings.criminal_certificate_request_home_title_ok5.localized()
        }
    }
}
