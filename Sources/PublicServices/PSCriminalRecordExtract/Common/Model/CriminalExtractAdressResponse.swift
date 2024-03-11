import Foundation

struct CriminalExtractAdressResponse: Codable {
    let title: String?
    let description: String?
    let parameters: [CriminalExtractAdressParametersResponse]?
    let address: CriminalExtractRegistrationAdressResponse?
}

struct CriminalExtractAdressParametersResponse: Codable {
    let type: CriminalExtractAdressType
    let label: String
    let hint: String
    let input: String
    let mandatory: Bool
    let source: CriminalExtractAdressItemsResponse
}

struct CriminalExtractAdressItemsResponse: Codable {
    let items: [CriminalExtractAdressSearchModel]
}

struct CriminalExtractRegistrationAdressResponse: Codable {
    let resourceId: String
    let fullName: String
}
