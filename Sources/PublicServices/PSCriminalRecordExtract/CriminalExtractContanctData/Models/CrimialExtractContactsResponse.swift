import Foundation

struct CrimialExtractContactsResponse: Codable {
    let title: String?
    let text: String
    let phoneNumber: String?
    let email: String?
}
