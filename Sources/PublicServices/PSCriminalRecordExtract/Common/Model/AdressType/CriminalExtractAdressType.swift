import Foundation

enum CriminalExtractAdressType: String, Codable {
    case country
    case region
    case district
    case city
    
    func getRequestModel(_ model: CriminalExtractAdressSearchModel) -> CriminalExtractAdressRequestItem? {
        return CriminalExtractAdressRequestItem(
            type: self.rawValue,
            id: model.id,
            value: model.name
        )
    }
}
