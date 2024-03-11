import Foundation
import Alamofire
import DiiaNetwork

public enum PublicServicesAPI: CommonService {
    static var context: PublicServiceCoreNetworkContext?

    case getServices
    case getPromo
    case subscribe(segmentId: Int)

    public var host: String {
        return PublicServicesAPI.context?.host ?? ""
    }

    public var timeoutInterval: TimeInterval {
        return 30
    }
    
    public var headers: [String: String]? {
        return PublicServicesAPI.context?.headers
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getServices, .getPromo:
            return .get
        case .subscribe:
            return .post
        }
    }
    
    public var path: String {
        switch self {
        case .getServices:
            return "v3/public-service/catalog"
        case .getPromo:
            return "v1/public-service/promo"
        case .subscribe:
            return "v1/user/subscription/public-service"
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getServices, .getPromo:
            return nil
        case .subscribe(let segmentId):
            return ["segmentId": "\(segmentId)"]
        }
    }

    public var analyticsName: String {
        switch self {
        case .getServices:
            return NetworkActionKey.getPublicServices.rawValue
        case .getPromo:
            return NetworkActionKey.getPublicServicesPromo.rawValue
        case .subscribe:
            return NetworkActionKey.subscribePublicServicesPromo.rawValue
        }
    }
    
    public var analyticsAdditionalParameters: String? { return nil }
}

private enum NetworkActionKey: String {
    // PublicServiceAPI
    case getPublicServices
    case getPublicServicesPromo
    case subscribePublicServicesPromo
}
