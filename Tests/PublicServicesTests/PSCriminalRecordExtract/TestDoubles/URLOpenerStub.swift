import Foundation
import DiiaCommonTypes

class URLOpenerStub: URLOpenerProtocol {
    func url(urlString: String?, linkType: String?) -> Bool {
        return false
    }
    
    func tryURL(urls: [String]) -> Bool {
        return false
    }
}
