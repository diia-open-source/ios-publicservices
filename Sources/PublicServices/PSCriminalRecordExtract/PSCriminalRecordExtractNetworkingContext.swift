import Foundation
import Alamofire

public struct PSCriminalRecordExtractNetworkingContext {
    public let session: Alamofire.Session
    public let host: String
    public let headers: [String: String]?
    
    public init(session: Alamofire.Session, host: String, headers: [String: String]?) {
        self.session = session
        self.host = host
        self.headers = headers
    }
}
