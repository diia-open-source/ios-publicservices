import Foundation

public struct CriminalExtractRequestModel: Codable {
    public var publicService: CriminalExtractRequestModelPublicService?
    public var reasonId: String?
    public var certificateType: String?
    public var previousFirstName: String?
    public var previousMiddleName: String?
    public var previousLastName: String?
    public var birthPlace: CriminalExtractBirthPlaceModel?
    public var nationalities: [String]?
    public var registrationAddressId: String?
    public var phoneNumber: String?
    public var email: String?
    
    public init(publicService: CriminalExtractRequestModelPublicService? = nil,
                reasonId: String? = nil,
                certificateType: String? = nil,
                previousFirstName: String? = nil,
                previousMiddleName: String? = nil,
                previousLastName: String? = nil,
                birthPlace: CriminalExtractBirthPlaceModel? = nil,
                nationalities: [String]? = nil,
                registrationAddressId: String? = nil,
                phoneNumber: String? = nil,
                email: String? = nil) {
        self.publicService = publicService
        self.reasonId = reasonId
        self.certificateType = certificateType
        self.previousFirstName = previousFirstName
        self.previousMiddleName = previousMiddleName
        self.previousLastName = previousLastName
        self.birthPlace = birthPlace
        self.nationalities = nationalities
        self.registrationAddressId = registrationAddressId
        self.phoneNumber = phoneNumber
        self.email = email
    }
}

public struct CriminalExtractRequestModelPublicService: Codable {
    public let code: String
    public let resourceId: String?
    
    public init(code: String, resourceId: String?) {
        self.code = code
        self.resourceId = resourceId
    }
}
