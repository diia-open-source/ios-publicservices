import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
@testable import DiiaPublicServices

class CriminalExtractStubService {
    var addressType: CriminalExtractAdressType
    
    init(addressType: CriminalExtractAdressType = .country) {
        self.addressType = addressType
    }
}

extension CriminalExtractStubService: CriminalExtractApiClientProtocol {
    func getIntro(publicService: String?) -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        let model = CertificateIntroModel(showContextMenu: true,
                                          title:"Вітаємо",
                                          text: "текст",
                                          attentionMessage: nil,
                                          nextScreen: .requester)
        return Signal(just: TemplatedResponse.data(model))
    }
    
    
    func getCriminalExtractList(category: CertificateStatus) -> Signal<TemplatedResponse<CriminalExtractListModel>, NetworkError> {
        
        switch category {
        case .applicationProcessing:
            return Signal(
                just: .data(
                    CriminalExtractListModel(
                        navigationPanel: nil,
                        certificatesStatus: .init(
                            code: .applicationProcessing,
                            name: "Замовлені"
                        ),
                        certificates: [
                            .init(
                                applicationId: "01",
                                status: category,
                                reason: "Надання до установ іноземних держав",
                                type: "Тип: повний",
                                creationDate: "від 02.03.2023"
                            )
                        ],
                        stubMessage: nil,
                        total: 1
                    )
                )
            )
        case .done:
            return Signal(
                just: .data(
                    CriminalExtractListModel(
                        navigationPanel: nil,
                        certificatesStatus: .init(
                            code: .done,
                            name: "Готові"
                        ),
                        certificates: [
                            .init(
                                applicationId: "01",
                                status: category,
                                reason: "Надання до установ іноземних держав",
                                type: "Тип: повний",
                                creationDate: "від 02.03.2023"
                            ),
                            .init(
                                applicationId: "02",
                                status: category,
                                reason: "Оформлення ліцензії на роботу з наркотичними засобами",
                                type: "Тип: повний",
                                creationDate: "від 02.03.2023"
                            ),
                            .init(
                                applicationId: "03",
                                status: category,
                                reason: "Оформлення на роботу",
                                type: "Тип: короткий",
                                creationDate: "від 02.03.2023"
                            )
                        ],
                        stubMessage: nil,
                        total: 3
                    )
                )
            )
        }
    }
    
    func getIntro() -> Signal<TemplatedResponse<CertificateIntroModel>, NetworkError> {
        return Signal(
            just: .data(
                CertificateIntroModel(
                    showContextMenu: true,
                    title: "Вітаємо",
                    text: nil,
                    attentionMessage: nil,
                    nextScreen: nil
                )
            )
        )
    }
    
    func getCertificateTypes() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal(
            just: .data(
                CertificatePickerModel(
                    title: "Мета запиту",
                    subtitle: "Для чого вам потрібен витяг?",
                    types: [
                        .init(
                            code: "1",
                            name: "Усиновлення, установлення опіки (піклування)",
                            description: nil
                        ),
                        .init(
                            code: "55",
                            name: "Оформлення дозволу на зброю",
                            description: nil
                        ),
                        .init(
                            code: "9",
                            name: "Оформлення громадянства",
                            description: nil
                        )
                    ],
                    reasons: nil
                )
            )
        )
    }
    
    func getBirthPlace() -> Signal<CriminalExtractBirthPlaceResponse, NetworkError> {
        return Signal(
            just: .init(
                birthPlaceDataScreen: .init(
                    title: "Місце народження",
                    country: .init(
                        label: "Країна",
                        hint: "Оберіть країну",
                        value: "УКРАЇНА",
                        checkbox: nil,
                        otherCountry: .init(
                            label: "Країна",
                            hint: "Введіть назву країни самостійно",
                            description: nil
                        )
                    ),
                    city: .init(
                        label: "Населений пункт",
                        hint: "Введіть населений пункт",
                        description: nil
                    ),
                    nextScreen: .contacts
                ),
                processCode: nil,
                template: nil
            )
        )
    }
    
    func fetchNationalityStatus() -> Signal<CriminalExtractNationalitiesResponse, NetworkError> {
        return Signal(
            just: .init(
                nationalitiesScreen: .init(
                    title: "Громадянство",
                    attentionMessage: .init(
                        title: nil,
                        text: nil,
                        icon: "",
                        parameters: nil
                    ),
                    country: .init(
                        label: "Країна",
                        hint: "Оберіть країну",
                        addAction: .init(
                            icon: "",
                            name: "Додати громадянство"
                        )
                    ),
                    maxNationalitiesCount: 2,
                    nextScreen: .registrationPlace
                ),
                processCode: nil,
                template: nil
            )
        )
    }
    
    func getNationalities() -> Signal<TemplatedResponse<CriminalExtractCountriesResponse>, NetworkError> {
        return Signal(
            just: .data(
                .init(
                    nationalities: [
                        .init(name: "Україна", code: "UA"),
                        .init(name: "Австрія", code: "AT"),
                        .init(name: "Автралія", code: "AU")
                    ]
                )
            )
        )
    }
    
    func getCertificateReasons() -> Signal<TemplatedResponse<CertificatePickerModel>, NetworkError> {
        return Signal(
            just: .data(
                CertificatePickerModel(
                    title: "Мета запиту",
                    subtitle: "Для чого вам потрібен витяг?",
                    types: nil,
                    reasons: [
                        .init(
                            code: "2",
                            name: "Оформлення візи для виїзду за кордон",
                            description: nil
                        )
                    ]
                )
            )
        )
    }
    
    func getRequester() -> Signal<CriminalExtractRequesterResponse, NetworkError> {
        return Signal(
            just: .init(
                requesterDataScreen: .init(
                    title: "Зміна особистих даних",
                    attentionMessage: .init(
                        title: nil,
                        text: "Вкажіть свої попередні ПІБ",
                        icon: "",
                        parameters: nil
                    ),
                    fullName: .init(
                        label: "Прізвище, імʼя, по батькові",
                        value: "Diia Test User"
                    ),
                    nextScreen: .birthPlace
                ),
                processCode: nil,
                template: nil
            )
        )
    }
    
    func getContacts() -> Signal<CrimialExtractContactsResponse, NetworkError> {
        return Signal(just: .init(title: "Test_Title",
                                  text: "Test_Text",
                                  phoneNumber: "Test_Title",
                                  email: "Test_Email"))
    }
    
    func getRegistrationAdress(adressModel: CriminalExtractAdressRequestItem?) -> Signal<TemplatedResponse<CriminalExtractAdressResponse>, NetworkError> {
        if adressModel != nil {
            return Signal(
                just: .data(
                    .init(
                        title: nil,
                        description: nil,
                        parameters: nil,
                        address: .init(
                            resourceId: "11111",
                            fullName: "Test_Address"
                        )
                    )
                )
            )
        }
        let parameters = getRegistrationAddressParameters(byType: addressType)
        return Signal(
            just: .data(
                .init(
                    title: nil,
                    description: nil,
                    parameters: parameters,
                    address: nil
                )
            )
        )
    }
    
    func getConfirmation(requestModel: CriminalExtractRequestModel) -> Signal<TemplatedResponse<CriminalExtractNewConfirmationModel>, NetworkError> {
        return Signal(
            just: .data(
                .init(
                    application: .init(
                        title: "Запит про надання витягу про несудимість",
                        attentionMessage: nil,
                        applicant: .init(
                            title: "Дані про заявника",
                            fullName: .init(label: "ПІБ", value: "Test User"),
                            previousFirstName: nil,
                            previousLastName: nil,
                            previousMiddleName: nil,
                            gender: .init(label: "Стать:", value: "Чоловік"),
                            nationality: .init(label: "Громадянство", value: "Україна"),
                            birthDate: .init(label: "Дата народження:", value: "06.12.1984"),
                            birthPlace: .init(label: "Місце народження:", value: "УКРАЇНА, Київ"),
                            registrationAddress: .init(
                                label: "Місце реєстрації проживання:",
                                value: "Україна, М. КИЇВ"
                            )
                        ),
                        contacts: .init(
                            title: "Контактні дані",
                            phoneNumber: .init(label: "Номер телефону:", value: "11111"),
                            email: nil
                        ),
                        certificateType: .init(
                            title: "Тип витягу",
                            type: "Притягнення до кримінальної відповідальності"
                        ),
                        reason: .init(
                            title: "Мета запиту",
                            reason: "Надання до установ іноземних держав"
                        ),
                        checkboxName: "OK"),
                    processCode: nil,
                    template: nil
                )
            )
        )
    }
    
    func getFileToShare(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal(just: .data(.init(file: Constants.file)))
    }
    
    func getFileToView(applicationId: String) -> Signal<TemplatedResponse<CertificateFileToShareModel>, NetworkError> {
        return Signal(just: .data(.init(file: Constants.file)))
    }
    
    func postApplication(requestModel: CriminalExtractRequestModel) -> Signal<CertificateApplicationResponseModel, NetworkError> {
        return Signal(
            just: .init(
                processCode: 1111,
                applicationId: "22222",
                template: .init(
                    type: .middleCenterAlignAlert,
                    isClosable: true,
                    data: .init(
                        icon: nil,
                        title: "Дякуємо, запит надіслано",
                        description: nil,
                        mainButton: .init(
                            title: nil,
                            icon: nil,
                            action: .criminalRecordCertificate
                        ),
                        alternativeButton: nil
                    )
                )
            )
        )
    }
    
    func getStatus(applicationId: String) -> Signal<TemplatedResponse<CriminalExtractStatusModel>, NetworkError> {
        return Signal(
            just: .data(
                .init(
                    title: "Запит про надання витягу про несудимість",
                    navigationPanel: nil,
                    statusMessage: nil,
                    status: .done,
                    loadActions: [
                        .init(
                            type: .downloadArchive,
                            icon: "",
                            name: "Завантажити архів"
                        ),
                        .init(
                            type: .viewPdf,
                            icon: "",
                            name: "Переглянути витяг"
                        )
                    ],
                    ratingForm: nil
                )
            )
        )
    }
}

// MARK: - Private Methods
private extension CriminalExtractStubService {
    func getRegistrationAddressParameters(
        byType type: CriminalExtractAdressType
    ) -> [CriminalExtractAdressParametersResponse] {
        switch addressType {
        case .country:
            return [
                .init(
                    type: .country,
                    label: "Країна*",
                    hint: "Оберіть країну",
                    input: "list",
                    mandatory: true,
                    source: .init(
                        items: [
                            .Ukraine,
                            .init(id: "40", name: "АВСТРІЯ")
                        ]
                    )
                )
            ]
        case .city:
            return [
                .init(
                    type: .city,
                    label: "Населений пункт*",
                    hint: "Оберіть населений пункт",
                    input: "list",
                    mandatory: true,
                    source: .init(
                        items: [
                            .init(id: "01", name: "КИЇВ"),
                            .init(id: "02", name: "ХАРКІВ")
                        ]
                    )
                )
            ]
        default:
            return []
        }
    }
}

private extension CriminalExtractStubService {
    enum Constants {
        static let file = "dGVzdERvY3VtZW50"
    }
}
