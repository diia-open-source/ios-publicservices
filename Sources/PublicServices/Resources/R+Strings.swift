import Foundation

internal extension R {
    enum Strings: String {
        
        // MARK: - General
        case general_next
        case general_details
        case general_sending
        case general_send
        
        // MARK: - Criminal Extract
        case criminal_extract_title
        
        // MARK: - Criminal Certificate Request
        case criminal_certificate_request_home_title
        case criminal_certificate_request_home_title_ok7
        case criminal_certificate_request_home_title_ok5
        case criminal_certificate_request_progress_label
        case criminal_certificate_request_intro_action_button
        case criminal_certificate_request_set_name_page_title
        case criminal_certificate_request_request_type
        case criminal_certificate_request_request_goal
        case criminal_certificate_request_request_goal_result
        case criminal_certificate_request_request_type_question
        case criminal_certificate_request_request_goal_question
        case criminal_certificate_request_address_picker_label_nationality
        case criminal_certificate_request_set_contacts_page_title
        case criminal_certificate_request_result_stack_view_title
        
        // MARK: - Criminal Certificate Data Type
        case criminal_certificate_data_type_title_fio
        case criminal_certificate_data_type_title_previousFirstName
        case criminal_certificate_data_type_title_previousSecondName
        case criminal_certificate_data_type_title_previousLastName
        case criminal_certificate_data_type_title_gender
        case criminal_certificate_data_type_title_residence
        case criminal_certificate_data_type_title_birth_date
        case criminal_certificate_data_type_title_birth_address
        case criminal_certificate_data_type_title_registration_address
        case criminal_certificate_data_type_title_phone_number
        
        // MARK: - Criminal Certificate Status View
        case criminal_certificate_status_view_page_alert_title_success
        case criminal_certificate_status_view_page_alert_desc_success
        case criminal_certificate_status_view_page_alert_emoji_success
        case criminal_certificate_status_view_page_alert_title_pending
        case criminal_certificate_status_view_page_alert_title_pending_ok
        case criminal_certificate_status_view_page_alert_desc_pending
        case criminal_certificate_status_view_page_alert_emoji_pending
        case criminal_certificate_status_view_page_alert_title_ready
        case criminal_certificate_status_view_page_alert_desc_ready
        case criminal_certificate_status_view_page_alert_emoji_ready
        
        // MARK: - Criminal Extract Birth Place
        case criminal_extract_birth_place_title
        case criminal_extract_birth_place_country_title
        case criminal_extract_birth_place_country_placeholder_list
        case criminal_extract_birth_place_country_placeholder_manual
        case criminal_extract_birth_place_checkBox
        
        // MARK: - CriminalCertListView
        case criminal_cert_list_done
        case criminal_cert_list_ordered
        
        // MARK: - CriminalExtractRequestName
        case criminal_extract_request_name_last_name
        case criminal_extract_request_name_first_name
        case criminal_extract_request_name_second_name
        
        case criminal_extract_request_name_last_name_previous
        case criminal_extract_request_name_first_name_previous
        case criminal_extract_request_name_second_name_previous
        
        case criminal_extract_request_name_last_name_add
        case criminal_extract_request_name_first_name_add
        case criminal_extract_request_name_second_name_add
        
        // MARK: - CriminalExtractNationalities
        case criminal_extract_nationalities_add_nationality
        case criminal_extract_nationalities_description
        
        // MARK: - CriminalExtractResult
        case criminal_extract_result_type_title
        case criminal_extract_result_document_name
        
        //MARK: - Certificates
        case certificate_name_from_ukr
        case certificate_name_from_translit
        case certificate_name_from_dot
        case certificate_name_from_dash
        
        // MARK: - RegistrationExtract
        case registration_extract_processing
        case registration_extract_done
        case registration_extract_action
        
        // MARK: - DriverLicense Replacement
        case driver_license_replacement_registration
        case address_registration_select_subtitle
        
        // MARK: - FOP
        case fop_contacts_title
        
        
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.module, comment: "")
            return String(format: localized, arguments)
        }
    }
}
