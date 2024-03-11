import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
@testable import DiiaPublicServices

class RatingServiceOpenerMock: RateServiceProtocol {
    func ratePublicServiceByRequest(publicServiceType: String, form: PublicServiceRatingForm, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func ratePublicServiceByUser(publicServiceType: String, screenCode: String?, resourceId: String?, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func rateDocument(documentType: String, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func rateDiiaIdByRequest(serviceCode: String, form: PublicServiceRatingForm, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
}
