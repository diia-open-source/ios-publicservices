import Foundation
import DiiaCommonTypes

struct CriminalExtractStatusModel: Codable {
    let title: String
    let navigationPanel: NavigationPanel?
    let statusMessage: AttentionMessage?
    let status: CertificateStatus
    let loadActions: [CriminalExtractStatusLoadAction]?
    let ratingForm: PublicServiceRatingForm?
}

struct CriminalExtractStatusLoadAction: Codable {
    let type: CriminalExtractLoadActionType
    let icon: String
    let name: String
}

enum CriminalExtractLoadActionType: String, Codable {
    case downloadArchive
    case viewPdf
}
