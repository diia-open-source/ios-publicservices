import Foundation
import DiiaCommonTypes
import DiiaUIComponents

struct CriminalExtractBirthPlaceResponse: Codable {
    let birthPlaceDataScreen: CriminalExtractBirthPlaceScreenResponse?
    let processCode: Int?
    let template: AlertTemplate?
}

struct CriminalExtractBirthPlaceScreenResponse: Codable {
    let title: String
    let country: CriminalExtractBirthPlaceCountryResponse
    let city: CriminalExtractBirthPlaceCityResponse
    let nextScreen: CriminalExtractScreen
}

struct CriminalExtractBirthPlaceCityResponse: Codable {
    let label, hint: String
    let description: String?
}

struct CriminalExtractBirthPlaceCountryResponse: Codable {
    let label, hint: String
    let value: String?
    let checkbox: String?
    let otherCountry: CriminalExtractBirthPlaceCityResponse?
}
