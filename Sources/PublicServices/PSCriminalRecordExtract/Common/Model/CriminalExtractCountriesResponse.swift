import Foundation

struct CriminalExtractCountriesResponse: Codable {
    let nationalities: [NationalitiesSearchModel]
}

struct NationalitiesSearchModel: Codable {
    let name: String
    let code: String
}
