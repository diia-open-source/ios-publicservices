import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes

protocol CriminalExtractApiClientProtocol {
    func getCriminalExtractList(category: CertificateStatus) -> Signal<TemplatedResponse<CriminalExtractListModel>, NetworkError>
    func getIntro(publicService: String?) -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError>
    func getCertificateTypes() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError>
    func getBirthPlace() -> Signal<CriminalExtractBirthPlaceResponse, NetworkError>
    func fetchNationalityStatus() -> Signal<CriminalExtractNationalitiesResponse, NetworkError>
    func getNationalities() -> Signal<TemplatedResponse<CriminalExtractCountriesResponse>, NetworkError>
    func getCertificateReasons() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError>
    func getRequester() -> Signal<CriminalExtractRequesterResponse, NetworkError>
    func getContacts() -> Signal<CrimialExtractContactsResponse, NetworkError>
    func getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?) -> Signal<TemplatedResponse<CriminalExtractAdressResponse>, NetworkError>
    func getConfirmation(requestModel: CriminalExtractRequestModel) -> Signal<TemplatedResponse<CriminalExtractNewConfirmationModel>, NetworkError>
    func getFileToShare(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError>
    func getFileToView(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError>
    func postApplication(requestModel: CriminalExtractRequestModel) -> Signal<CertificateApplicationResponseModel, NetworkError>
    func getStatus(applicationId: String) -> Signal<TemplatedResponse<CriminalExtractStatusModel>, NetworkError>
}

class CriminalExtractApiClient: ApiClient<CriminalExtractApi>, CriminalExtractApiClientProtocol {
    init(context: PSCriminalRecordExtractNetworkingContext) {
        super.init()

        sessionManager = context.session
        CriminalExtractApi.host = context.host
        CriminalExtractApi.headers = context.headers
    }

    func getCriminalExtractList(category: CertificateStatus) -> Signal<TemplatedResponse<CriminalExtractListModel>, NetworkError> {
        return request(
            .getExtracts(status: category)
        )
    }
    
    func getIntro(publicService: String?) -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return request(.getIntro(publicService: publicService))
    }
    
    func getCertificateTypes() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return request(.getCertificateTypes)
    }
    
    func getBirthPlace() -> Signal<CriminalExtractBirthPlaceResponse, NetworkError> {
        return request(.getBirthPlace)
    }
    
    func fetchNationalityStatus() -> Signal<CriminalExtractNationalitiesResponse, NetworkError> {
        return request(.getNationalityStatus)
    }
    
    func getNationalities() -> Signal<TemplatedResponse<CriminalExtractCountriesResponse>, NetworkError> {
        return request(.getNationalities)
    }
    
    func getCertificateReasons() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return request(.getCertificateReasons)
    }
    
    func getRequester() -> Signal<CriminalExtractRequesterResponse, NetworkError> {
        return request(.getRequester)
    }
    
    func getContacts() -> Signal<CrimialExtractContactsResponse, NetworkError> {
        return request(.getContacts)
    }
    
    func getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?) -> Signal<TemplatedResponse<CriminalExtractAdressResponse>, NetworkError> {
        return request(.getRegistrationAdress(adressModel: adressModel))
    }
    
    func getConfirmation(requestModel: CriminalExtractRequestModel) -> Signal<TemplatedResponse<CriminalExtractNewConfirmationModel>, NetworkError> {
        return request(.getConfirmation(requestModel: requestModel))
    }
    
    func getFileToShare(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return request(.getFileToShare(applicationId: applicationId))
    }
    
    func getFileToView(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return request(.getFileToView(applicationId: applicationId))
    }
    
    func postApplication(requestModel: CriminalExtractRequestModel) -> Signal<CertificateApplicationResponseModel, NetworkError> {
        return request(.postApplication(requestModel: requestModel))
    }
    
    func getStatus(applicationId: String) -> Signal<TemplatedResponse<CriminalExtractStatusModel>, NetworkError> {
        return request(.getStatus(applicationId: applicationId))
    }
}
