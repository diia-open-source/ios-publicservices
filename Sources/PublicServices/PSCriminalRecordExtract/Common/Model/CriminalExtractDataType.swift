import Foundation

enum CriminalExtractDataType: CaseIterable {
    case fio
    case previousFirstName
    case previousSecondName
    case previousLastName
    case gender
    case residence
    case birthDate
    case placeOfBirth
    case placeOfRegistration
    case phoneNumber
    
    var title: String {
        switch self {
        case .fio:
            return R.Strings.criminal_certificate_data_type_title_fio.localized()
        case .previousFirstName:
            return R.Strings.criminal_certificate_data_type_title_previousFirstName.localized()
        case .previousSecondName:
            return  R.Strings.criminal_certificate_data_type_title_previousSecondName.localized()
        case .previousLastName:
            return  R.Strings.criminal_certificate_data_type_title_previousLastName.localized()
        case .gender:
            return R.Strings.criminal_certificate_data_type_title_gender.localized()
        case .residence:
            return R.Strings.criminal_certificate_data_type_title_residence.localized()
        case .birthDate:
            return R.Strings.criminal_certificate_data_type_title_birth_date.localized()
        case .placeOfBirth:
            return R.Strings.criminal_certificate_data_type_title_birth_address.localized()
        case .placeOfRegistration:
            return R.Strings.criminal_certificate_data_type_title_registration_address.localized()
        case .phoneNumber:
            return R.Strings.criminal_certificate_data_type_title_phone_number.localized()
        }
    }
    
    static var orderedKeys: [CriminalExtractDataType] {
        return [
            .fio,
            .previousLastName,
            .previousFirstName,
            .previousSecondName,
            .gender,
            .residence,
            .birthDate,
            .placeOfBirth,
            .placeOfRegistration
        ]
    }
}
