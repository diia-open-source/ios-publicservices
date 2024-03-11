import Foundation

public struct CriminalExtractBirthPlaceModel: Codable {
    public let country: String
    public let city: String
    
    init(country: String, city: String) {
        self.country = country
        self.city = city
    }
}
