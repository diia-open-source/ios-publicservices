import Foundation
import ReactiveKit
import Alamofire
import DiiaNetwork
import DiiaCommonTypes

public protocol PublicServicesAPIClientProtocol: AnyObject {
    func getPublicServices() -> Signal<PublicServiceResponse, NetworkError>
    func getPromo() -> Signal<AlertTemplateResponse, NetworkError>
    func subscribe(segmentId: Int) -> Signal<SuccessResponse, NetworkError>
}

public class PublicServicesAPIClient: ApiClient<PublicServicesAPI>, PublicServicesAPIClientProtocol {

    public init(context: PublicServiceCoreNetworkContext) {
        super.init()
        sessionManager = context.session
        PublicServicesAPI.context = context
    }
    
    public func getPublicServices() -> Signal<PublicServiceResponse, NetworkError> {
        return request(.getServices)
    }
    
    public func getPromo() -> Signal<AlertTemplateResponse, NetworkError> {
        return request(.getPromo)
    }
    
    public func subscribe(segmentId: Int) -> Signal<SuccessResponse, NetworkError> {
        return request(.subscribe(segmentId: segmentId))
    }

}
