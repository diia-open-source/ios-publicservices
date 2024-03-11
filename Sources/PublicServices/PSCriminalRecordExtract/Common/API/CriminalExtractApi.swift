import Foundation
import DiiaNetwork
import DiiaCommonTypes

enum CriminalExtractApi: CommonService {
    static var host: String = ""
    static var headers: [String: String]?
    
    case getExtracts(status: CertificateStatus)
    case getIntro(publicService: String?)
    case getCertificateTypes
    case getCertificateReasons
    case getRequester
    case getBirthPlace
    case getNationalityStatus
    case getNationalities
    case getContacts
    case getConfirmation(requestModel: CriminalExtractRequestModel)
    case getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?)
    case getStatus(applicationId: String)
    case getFileToShare(applicationId: String)
    case getFileToView(applicationId: String)
    case postApplication(
        requestModel: CriminalExtractRequestModel
    )
    
    var method: HTTPMethod {
        switch self {
        case .getExtracts,
                .getIntro,
                .getCertificateTypes,
                .getCertificateReasons,
                .getBirthPlace,
                .getNationalityStatus,
                .getNationalities,
                .getRequester,
                .getContacts,
                .getFileToShare,
                .getFileToView,
                .getStatus:
            return .get
        case .postApplication,
                .getRegistrationAdress,
                .getConfirmation:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getExtracts(let type):
            return "v1/public-service/criminal-cert/applications/\(type.rawValue)"
        case .getIntro:
            return "v1/public-service/criminal-cert/application/info"
        case .getCertificateTypes:
            return "v1/public-service/criminal-cert/types"
        case .getCertificateReasons:
            return "v1/public-service/criminal-cert/reasons"
        case .getRequester:
            return "v1/public-service/criminal-cert/requester"
        case .getBirthPlace:
            return "v1/public-service/criminal-cert/birth-place"
        case .getNationalities:
            return "v1/address/nationalities"
        case .getNationalityStatus:
            return "v1/public-service/criminal-cert/nationalities"
        case .getContacts:
            return "v1/public-service/criminal-cert/contacts"
        case .getConfirmation:
            return "v1/public-service/criminal-cert/confirmation"
        case .postApplication:
            return "v1/public-service/criminal-cert/application"
        case .getFileToShare(let applicationId):
            return "v1/public-service/criminal-cert/\(applicationId)/download"
        case .getFileToView(let applicationId):
            return "v1/public-service/criminal-cert/\(applicationId)/pdf"
        case .getStatus(let applicationId):
            return "v1/public-service/criminal-cert/\(applicationId)"
        case .getRegistrationAdress:
            return "v1/address/criminal-cert/registration-place"
        }
    }
    
    var host: String {
        return CriminalExtractApi.host
    }
    
    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var headers: [String: String]? {
        return CriminalExtractApi.headers
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getIntro(let publicService):
            if let publicService = publicService {
                return ["publicService": publicService]
            }
            return nil
        case .getExtracts:
            return [
                "skip": 0,
                "limit": 20
            ]
        case .postApplication(let requestModel):
            return requestModel.dictionary
        case .getRegistrationAdress(let model):
            guard let existingModel = model else { return nil }
            return CriminalExtractAdressRequestModel(values: [existingModel]).dictionary
        case .getConfirmation(let requestModel):
            return requestModel.dictionary
        default:
            return nil
        }
    }
    
    var analyticsAdditionalParameters: String? { return nil }
    
    var analyticsName: String {
        switch self {
        case .getExtracts:
            return NetworkActionKey.criminalRecordExtract.rawValue
        case .getIntro:
            return NetworkActionKey.criminalRecordExtractIntro.rawValue
        case .getCertificateTypes:
            return NetworkActionKey.criminalRecordExtractGetCertificateTypes.rawValue
        case .getCertificateReasons:
            return NetworkActionKey.criminalRecordExtractGetCertificateReasons.rawValue
        case .getRequester:
            return NetworkActionKey.criminalRecordExtractGetRequester.rawValue
        case .getBirthPlace:
            return NetworkActionKey.criminalRecordExtractGetBirthPlace.rawValue
        case .getNationalityStatus:
            return NetworkActionKey.criminalRecordExtractGetNationalityStatus.rawValue
        case .getNationalities:
            return NetworkActionKey.criminalRecordExtractGetNationalities.rawValue
        case .getContacts:
            return NetworkActionKey.criminalRecordExtractGetContacts.rawValue
        case .getConfirmation:
            return NetworkActionKey.criminalRecordExtractGetConfirmation.rawValue
        case .getRegistrationAdress:
            return NetworkActionKey.criminalRecordExtractGetRegistrationAdress.rawValue
        case .getStatus:
            return NetworkActionKey.criminalRecordExtractGetStatus.rawValue
        case .getFileToShare:
            return NetworkActionKey.criminalRecordExtractGetFileToShare.rawValue
        case .getFileToView:
            return NetworkActionKey.criminalRecordExtractGetFileToView.rawValue
        case .postApplication:
            return NetworkActionKey.criminalRecordExtractPostApplication.rawValue
        }
    }
}

private enum NetworkActionKey: String {
    // CriminalExtractAPI
    case criminalRecordExtract
    case criminalRecordExtractIntro
    case criminalRecordExtractGetCertificateTypes
    case criminalRecordExtractGetCertificateReasons
    case criminalRecordExtractGetRequester
    case criminalRecordExtractGetBirthPlace
    case criminalRecordExtractGetNationalityStatus
    case criminalRecordExtractGetNationalities
    case criminalRecordExtractGetContacts
    case criminalRecordExtractGetConfirmation
    case criminalRecordExtractGetRegistrationAdress
    case criminalRecordExtractGetStatus
    case criminalRecordExtractGetFileToShare
    case criminalRecordExtractGetFileToView
    case criminalRecordExtractPostApplication
}
