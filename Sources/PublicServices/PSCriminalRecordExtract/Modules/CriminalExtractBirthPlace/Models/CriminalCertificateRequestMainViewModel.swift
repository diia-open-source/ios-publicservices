import Foundation
import DiiaCommonTypes

public class CriminalCertificateRequestMainViewModel {
    public let applicationId: String
    public let status: String
    public let date: String
    public let type: String
    public let documentsCount: Int
    public let action: Action
    public let reason: String
    
    public init(
        applicationId: String = "",
        status: String,
        date: String,
        type: String,
        documentsCount: Int,
        action: Action
    ) {
        self.applicationId = applicationId
        self.status = status
        self.date = date
        self.type = type
        self.documentsCount = documentsCount
        self.reason = .empty
        self.action = action
    }
    
    public init(
        certificate: CriminalExtractModel,
        action: Action
    ) {
        self.applicationId = certificate.applicationId
        self.status = certificate.status.rawValue
        self.date = certificate.creationDate
        self.reason = certificate.reason
        self.type = certificate.type
        self.documentsCount = .zero
        self.action = action
    }
}
