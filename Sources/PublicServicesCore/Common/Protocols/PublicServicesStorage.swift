import Foundation

public protocol PublicServicesStorage {
    func savePublicServicesResponse(response: PublicServiceResponse)
    func getPublicServicesResponse() -> PublicServiceResponse?
}
