import Foundation

public enum CriminalCertStatusScreenType {
    case pendig
    case success
    case ready

    var certificateStatus: CertificateStatus {
        switch self {
        case .pendig:
            return .applicationProcessing
        case .success:
            return .done
        case .ready:
            return .done
        }
    }

    public var statusTitle: String {
        switch self {
        case .pendig:
            return R.Strings.criminal_certificate_status_view_page_alert_title_pending.localized()
        case .success:
            return R.Strings.criminal_certificate_status_view_page_alert_title_success.localized()
        case .ready:
            return R.Strings.criminal_certificate_status_view_page_alert_title_ready.localized()
        }
    }

    public var statusDescription: String {
        switch self {
        case .pendig:
            return R.Strings.criminal_certificate_status_view_page_alert_desc_pending.localized()
        case .success:
            return R.Strings.criminal_certificate_status_view_page_alert_desc_success.localized()
        case .ready:
            return R.Strings.criminal_certificate_status_view_page_alert_desc_ready.localized()
        }
    }

    public var statusEmoji: String {
        switch self {
        case .pendig:
            return R.Strings.criminal_certificate_status_view_page_alert_emoji_pending.localized()
        case .success:
            return R.Strings.criminal_certificate_status_view_page_alert_emoji_success.localized()
        case .ready:
            return R.Strings.criminal_certificate_status_view_page_alert_emoji_ready.localized()
        }
    }
}
