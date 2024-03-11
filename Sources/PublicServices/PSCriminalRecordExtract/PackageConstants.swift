import Foundation
import DiiaCommonTypes

struct PackageConstants {
    static let packageServiceType = "criminalRecordCertificate"
    
    // Static dependencies
    static var ratingServiceOpener: RateServiceProtocol?
    static var urlOpener: URLOpenerProtocol?
}
