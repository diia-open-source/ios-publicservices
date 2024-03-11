import Foundation
import DiiaCommonTypes
import DiiaUIComponents

struct CriminalExtractNationalitiesResponse: Codable {
    let nationalitiesScreen: CriminalExtractNationalitiesScreenResponse?
    let processCode: Int?
    let template: AlertTemplate?
}

struct CriminalExtractNationalitiesScreenResponse: Codable {
    let title: String
    let attentionMessage: ParameterizedAttentionMessage
    let country: CriminalExtractNationalitiesItem
    let maxNationalitiesCount: Int
    let nextScreen: CriminalExtractScreen
}

struct CriminalExtractNationalitiesItem: Codable {
    let label: String
    let hint: String
    let addAction: CriminalExtractNationlitiesAction?
}

struct CriminalExtractNationlitiesAction: Codable {
    let icon: String
    let name: String
}
