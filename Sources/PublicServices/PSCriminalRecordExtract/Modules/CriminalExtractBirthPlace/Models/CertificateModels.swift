import Foundation
import DiiaCommonTypes
import DiiaUIComponents

// MARK: - CertificateStatus
public enum CertificateStatus: String, Codable {
    case applicationProcessing
    case done

    public func description(by type: OKCertificateType) -> String {
        switch self {
        case .applicationProcessing:
            return R.Strings.criminal_certificate_status_view_page_alert_title_pending_ok.localized()
        case .done:
            return ""
        }
    }
}

// MARK: - Intro Model
public struct CertificateIntroModel: Codable {
    public let showContextMenu: Bool?
    public let title: String?
    public let text: String?
    public let attentionMessage: ParameterizedAttentionMessage?
    public let nextScreen: CertificateNextStep?
}

public enum CertificateNextStep: String, Codable {
    case reasons
    case requester
}

// MARK: - Picker Model
public struct CertificatePickerModel: Codable {
    public let title: String
    public let subtitle: String
    public let types: [CertificatePickerTypeModel]?
    public let reasons: [CertificatePickerTypeModel]?
}

public struct CertificatePickerTypeModel: Codable {
    public let code: String
    public let name: String
    public let description: String?
}

// MARK: - ApplicationResponse
public struct CertificateApplicationResponseModel: Codable {
    public let processCode: Int?
    public let applicationId: String?
    public let template: AlertTemplate
}

public struct CertificateFileToShareModel: Codable {
    public let file: String
}
