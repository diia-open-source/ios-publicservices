import UIKit
import Dispatch
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractBirthPlaceAction: BasePresenter {
    typealias ViewModel = CriminalExtractBirthPlaceViewModel
    var isCountryOutOfList: Bool { get }
    var isCountryProvided: Bool { get }
    var numberOfSections: Int { get }
    func openContextMenu()
    func actionTapped()
    func viewModelForSection(section: Int) -> ViewModel
}

final class CriminalExtractBirthPlacePresenter: CriminalExtractBirthPlaceAction {

    typealias ViewModel = CriminalExtractBirthPlaceViewModel
    
	// MARK: - Properties
   
    unowned var view: CriminalExtractBirthPlaceView
    
    var isCountryOutOfList: Bool {
        return _isCountryOutOfList
    }
    
    var numberOfSections: Int {
        switch isEditableCountry {
        case true:
            return Constants.numberOfSectionsWithCountry
        case false:
            return Constants.numberOfSectionsWithoutCountry
        }
    }
    
    var isCountryProvided: Bool {
        return !isEditableCountry
    }
    
    private var currentCountry: String = .empty {
        didSet {
            validate()
        }
    }
    
    private var currentCity: String = .empty {
        didSet {
            validate()
        }
    }
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let apiClient: CriminalExtractApiClientProtocol
    private let bag = DisposeBag()
    private var requestModel: CriminalExtractRequestModel
    private var didRetry = false
    private var isEditableCountry = true
    private var _isCountryOutOfList = false
    private var items: [SearchModel] = []
    private var cityTextModel: CriminalExtractBirthPlaceCityResponse?
    private var countryTextModel: CriminalExtractBirthPlaceCountryResponse?
    private var nextScreen: CriminalExtractScreen?
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    
    // MARK: - Init
    init(
        view: CriminalExtractBirthPlaceView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        apiClient: CriminalExtractApiClientProtocol,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.apiClient = apiClient
        self.requestModel = requestModel
        self.networkingContext = networkingContext
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setContextMenuAvailable(isAvailable: false)
        view.setLoadingState(.loading)
        fetchCountries()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped() {
        guard let screen = nextScreen else { return }
        requestModel.birthPlace = CriminalExtractBirthPlaceModel(
            country: currentCountry,
            city: currentCity
        )
        
        flowCoordinator.openNextScreen(
            screen: screen,
            model: requestModel,
            contextProvider: contextMenuProvider,
            networkingContext: networkingContext,
            in: view
        )
    }
    
    func viewModelForSection(section: Int) -> ViewModel {
        let title: String
        let placeholder: String
        let text: String?
        let description: String?
        let isValid: Bool
        let isEditable: Bool
        let toggleAction: ((Bool) -> Void)?
        let updateTextAction: ((ViewModel.TextFieldState) -> Void)?
        
        if !isEditableCountry {
            title = cityTextModel?.label ?? .empty
            placeholder = cityTextModel?.hint ?? .empty
            description = cityTextModel?.description ?? .empty
            text = currentCity
            isValid = isValidAppearance(string: currentCity)
            isEditable = true
            toggleAction = nil
            updateTextAction = { [weak self] state in
                switch state {
                case .editing(let text):
                    guard let text = text else { return }
                    self?.currentCity = text
                    self?.validate()
                case .finishedEdit(let text):
                    guard let text = text else { return }
                    self?.currentCity = text
                    self?.validate()
                    self?.view.updateSection(index: 1)
                }
            }
        } else {
            switch section {
            case .zero:
                title = countryTextModel?.label ?? .empty
                placeholder = countryTextModel?.hint ?? .empty
                description = nil
                text = currentCountry
                isValid = isValidAppearance(string: currentCountry)
                isEditable = isEditableCountry
                toggleAction = { [weak self] bool in
                    self?.currentCountry = .empty
                    self?._isCountryOutOfList = bool
                    self?.view.updateSection(index: .zero)
                }
                updateTextAction = { [weak self] state in
                    switch state {
                    case .editing(let text):
                        if let text = text {
                            self?.currentCountry = text
                        }
                    case .finishedEdit(let text):
                        if let text = text,
                           let bool = self?.isCountryOutOfList,
                           bool == true {
                            self?.currentCountry = text
                        } else if text == nil,
                                  let bool = self?.isCountryOutOfList,
                                  bool == false {
                            self?.openCoutryList()
                        }
                    }
                }
                
            default:
                title = cityTextModel?.label ?? .empty
                placeholder = cityTextModel?.hint ?? .empty
                description = cityTextModel?.description ?? .empty
                text = currentCity
                isValid = isValidAppearance(string: currentCity)
                isEditable = true
                toggleAction = nil
                updateTextAction = { [weak self] state in
                    switch state {
                    case .editing(let text):
                        guard let text = text else { return }
                        self?.currentCity = text
                        self?.validate()
                    case .finishedEdit(let text):
                        guard let text = text else { return }
                        self?.currentCity = text
                        self?.validate()
                        self?.view.updateSection(index: 1)
                    }
                }
            }
        }
        
        return ViewModel(
            title: title,
            placeholder: placeholder,
            text: text,
            description: description,
            toggleState: isCountryOutOfList,
            isValidAppearance: isValid,
            isEditable: isEditable,
            toggleAction: toggleAction,
            updateTextAction: updateTextAction
        )
    }
    
    // MARK: - Private Methods
    
    private func openCoutryList() {
        view.open(
            module: BaseSearchModule(
                items: items
            ) { [weak self] model in
                self?.currentCountry = model.title
                self?.view.updateSection(index: .zero)
            }
        )
    }
    
    private func isValidAppearance(string: String) -> Bool {
        return string.isEmpty || isValid(string: string)
    }
    
    private func validate() {
        view.setActionButtonActive(
            isValid(string: currentCountry) && isValid(string: currentCity)
        )
    }
    
    @discardableResult
    private func isValid(string: String) -> Bool {
        let literalRegex = #"^[А-ЩЬЮЯҐЄІЇа-щьюяґєії \x{2019} ʼ [:punct:]]{1,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", literalRegex)
        return test.evaluate(with: string)
    }
    
    private func fetchCountries() {
        apiClient
            .getRegistrationAdress(adressModel: nil)
            .observe { [weak self] signal in
                switch signal {
                case .next(let data):
                    switch data {
                    case .data(let response):
                        self?.didRetry = false
                        self?.handleAdressResponse(data: response)
                        self?.fetchBirthPlace()
                    case .template(let template):
                        self?.handleTempalte(template)
                    }
                case .failed(let error):
                    self?.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchCountries()
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleAdressResponse(data: CriminalExtractAdressResponse) {
        if let parameters = data.parameters?.first {
            switch parameters.type {
            case .country:
                let adressItems = parameters.source.items
                items = adressItems.map({ SearchModel(code: $0.id, title: $0.name) })
            default:
                break
            }
        }
    }
    
    private func fetchBirthPlace() {
        apiClient
            .getBirthPlace()
            .observe { [weak self] result in
                switch result {
                case .next(let data):
                    if let response = data.birthPlaceDataScreen {
                        self?.handleScreenResponse(response)
                    } else if let template = data.template {
                        self?.handleTempalte(template)
                    }
                case .failed(let error):
                    self?.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchCountries()
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleScreenResponse(_ response: CriminalExtractBirthPlaceScreenResponse) {
        didRetry = false
        cityTextModel = response.city
        countryTextModel = response.country
        view.setContextMenuAvailable(isAvailable: true)
        if let country =  response.country.value,
           !country.isEmpty {
            currentCountry = country
            isEditableCountry = false
        }
        nextScreen = response.nextScreen
        validate()
        view.setLoadingState(.ready)
    }
    
    private func handleTempalte(_ template: AlertTemplate) {
        TemplateHandler.handle(template, in: view, callback: { [weak self] action in
            if action == .criminalRecordCertificate {
                self?.view.closeModule(animated: true)
            }
        })
    }
    
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: { [weak self] in
                self?.didRetry = true
                retryAction()
            },
            didRetry: didRetry,
            in: view
        )
    }
}

extension CriminalExtractBirthPlacePresenter {
    enum Constants {
        static let numberOfSectionsWithCountry = 2
        static let numberOfSectionsWithoutCountry = 1
    }
}
