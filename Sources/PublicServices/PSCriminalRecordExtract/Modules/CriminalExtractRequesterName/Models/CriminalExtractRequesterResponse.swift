import Foundation
import DiiaUIComponents
import DiiaCommonTypes

struct CriminalExtractRequesterResponse: Codable {
    let requesterDataScreen: RequesterDataScreenModel?
    let processCode: Int?
    let template: AlertTemplate?
}

struct RequesterDataScreenModel: Codable {
    let title: String
    let attentionMessage: ParameterizedAttentionMessage?
    let fullName: LabelValueModel
    let nextScreen: CriminalExtractScreen
}
