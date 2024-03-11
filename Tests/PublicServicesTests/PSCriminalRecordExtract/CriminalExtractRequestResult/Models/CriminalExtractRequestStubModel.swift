import Foundation
@testable import DiiaPublicServices

struct CriminalExtractRequestStubModel {
    var model: CriminalExtractRequestModel {
        return CriminalExtractRequestModel(
            reasonId: "56",
            certificateType: "full",
            birthPlace: CriminalExtractBirthPlaceModel(country: "УКРАЇНА", city: "Київ"),
            phoneNumber: "11111"
        )
    }
}
