import Foundation

struct CriminalCertificatesRequestPickerModel {
    var type: CriminalCertificateRequestPickerType
    var items: [CriminalCertificatesRequestPickerItemModel]
    var step: Int
    var numberOfSteps: Int
    
    init(type: CriminalCertificateRequestPickerType,
         items: [CriminalCertificatesRequestPickerItemModel],
         step: Int,
         numberOfSteps: Int) {
        self.type = type
        self.items = items
        self.step = step
        self.numberOfSteps = numberOfSteps
    }
}

enum CriminalCertificateRequestPickerType: String {
    case type
    case goal
    
    var title: String {
        switch self {
        case .type:
            return R.Strings.criminal_certificate_request_request_type.localized()
        case .goal:
            return R.Strings.criminal_certificate_request_request_goal.localized()
        }
    }
    
    var subtitle: String {
        switch self {
        case .type:
            return R.Strings.criminal_certificate_request_request_type_question.localized()
        case .goal:
            return R.Strings.criminal_certificate_request_request_goal_question.localized()
        }
    }
}
