import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
@testable import DiiaPublicServices

class CriminalExtractStubErrorService: CriminalExtractApiClientProtocol {
    func getIntro(publicService: String?) -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getCriminalExtractList(category: CertificateStatus) -> Signal<TemplatedResponse<CriminalExtractListModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getIntro() -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getCertificateTypes() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getBirthPlace() -> Signal<CriminalExtractBirthPlaceResponse, NetworkError> {
        Signal.failed(.noData)
    }
    
    func fetchNationalityStatus() -> Signal<CriminalExtractNationalitiesResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getNationalities() -> Signal<TemplatedResponse<CriminalExtractCountriesResponse>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getCertificateReasons() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getRequester() -> Signal<CriminalExtractRequesterResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getContacts() -> Signal<CrimialExtractContactsResponse, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?) -> Signal<TemplatedResponse<CriminalExtractAdressResponse>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getConfirmation(requestModel: CriminalExtractRequestModel) -> Signal<TemplatedResponse<CriminalExtractNewConfirmationModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getFileToShare(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getFileToView(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func postApplication(requestModel: CriminalExtractRequestModel) -> Signal<CertificateApplicationResponseModel, NetworkError> {
        return Signal.failed(.noData)
    }
    
    func getStatus(applicationId: String) -> Signal<TemplatedResponse<CriminalExtractStatusModel>, NetworkError> {
        return Signal.failed(.noData)
    }
    
}
