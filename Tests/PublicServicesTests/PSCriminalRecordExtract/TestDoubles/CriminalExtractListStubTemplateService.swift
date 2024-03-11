import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractListStubTemplateService { }

extension CriminalExtractListStubTemplateService: CriminalExtractApiClientProtocol {
    func getIntro(publicService: String?) -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    
    func getCriminalExtractList(category: CertificateStatus) -> Signal<TemplatedResponse<CriminalExtractListModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getIntro() -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getCertificateTypes() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getBirthPlace() -> Signal<CriminalExtractBirthPlaceResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func fetchNationalityStatus() -> Signal<CriminalExtractNationalitiesResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getNationalities() -> Signal<TemplatedResponse<CriminalExtractCountriesResponse>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getCertificateReasons() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getRequester() -> Signal<CriminalExtractRequesterResponse, NetworkError> {
        return Signal(just: .init(requesterDataScreen: nil, processCode: nil, template: .generalErrorAlert))
    }
    
    func getContacts() -> Signal<CrimialExtractContactsResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?) -> Signal<TemplatedResponse<CriminalExtractAdressResponse>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getConfirmation(requestModel: CriminalExtractRequestModel) -> Signal<TemplatedResponse<CriminalExtractNewConfirmationModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getFileToShare(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func getFileToView(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
    
    func postApplication(requestModel: CriminalExtractRequestModel) -> Signal<CertificateApplicationResponseModel, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getStatus(applicationId: String) -> Signal<TemplatedResponse<CriminalExtractStatusModel>, NetworkError> {
        return Signal(just: .template(.generalErrorAlert))
    }
}
