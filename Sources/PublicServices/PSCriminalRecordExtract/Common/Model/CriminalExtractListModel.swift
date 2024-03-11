import Foundation
import DiiaCommonTypes

struct CriminalExtractListModel: Codable {
    let navigationPanel: NavigationPanel?
    let certificatesStatus: CriminalExtractListStatusModel?
    let certificates: [CriminalExtractModel]?
    let stubMessage: AttentionMessage?
    let total: Int
}

public struct CriminalExtractModel: Codable {
    public let applicationId: String
    public let status: CertificateStatus
    public let reason: String
    public let type: String
    public let creationDate: String
    
    public init(applicationId: String, status: CertificateStatus, reason: String, type: String, creationDate: String) {
        self.applicationId = applicationId
        self.status = status
        self.reason = reason
        self.type = type
        self.creationDate = creationDate
    }
}

struct CriminalExtractListStatusModel: Codable {
    let code: CertificateStatus
    let name: String
}
