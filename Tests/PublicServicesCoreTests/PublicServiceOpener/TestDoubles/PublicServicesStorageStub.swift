import Foundation
@testable import DiiaPublicServicesCore

struct PublicServicesStorageStub: PublicServicesStorage {
    func savePublicServicesResponse(response: DiiaPublicServicesCore.PublicServiceResponse) {}

    func getPublicServicesResponse() -> DiiaPublicServicesCore.PublicServiceResponse? {
        nil
    }

    func saveServicesGridEnabled(enabled: Bool) {}
    
    func getServicesGridEnabled() -> Bool? {
        nil
    }
}
