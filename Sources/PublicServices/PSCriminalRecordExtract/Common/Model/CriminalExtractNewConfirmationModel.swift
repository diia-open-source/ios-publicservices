import Foundation
import DiiaCommonTypes

struct CriminalExtractNewConfirmationModel: Codable {
    let application: CriminalExtractConfirmationAplication
    let processCode: String?
    let template: AlertTemplate?
}

struct CriminalExtractConfirmationAplication: Codable {
    let title: String
    let attentionMessage: AttentionMessage?
    let applicant: CriminalExtractConfirmationAplicant
    let contacts: CriminalCertConfirmationContacts
    let certificateType: CriminalCertConfirmationCertType
    let reason: CriminalCertConfirmationReason
    let checkboxName: String
}

struct CriminalExtractConfirmationAplicant: Codable {
    let title: String
    let fullName: LabelValueModel
    let previousFirstName, previousLastName, previousMiddleName: LabelValueModel?
    let gender, nationality, birthDate, birthPlace, registrationAddress: LabelValueModel
}

struct CriminalCertConfirmationContacts: Codable {
    let title: String
    let phoneNumber: LabelValueModel
    let email: LabelValueModel?
}

struct CriminalCertConfirmationCertType: Codable {
    let title: String
    let type: String
}

struct CriminalCertConfirmationReason: Codable {
    let title: String
    let reason: String
}

extension CriminalExtractNewConfirmationModel {
    func getModelFor(_ type: CriminalExtractDataType ) -> LabelValueModel? {
        switch type {
        case .fio:
            return application.applicant.fullName
        case .previousFirstName:
            return application.applicant.previousFirstName
        case .previousSecondName:
            return application.applicant.previousMiddleName
        case .previousLastName:
            return application.applicant.previousLastName
        case .gender:
            return application.applicant.gender
        case .residence:
            return application.applicant.nationality
        case .birthDate:
            return application.applicant.birthDate
        case .placeOfBirth:
            return application.applicant.birthPlace
        case .placeOfRegistration:
            return application.applicant.registrationAddress
        case .phoneNumber:
            return application.contacts.phoneNumber
        }
    }
}
