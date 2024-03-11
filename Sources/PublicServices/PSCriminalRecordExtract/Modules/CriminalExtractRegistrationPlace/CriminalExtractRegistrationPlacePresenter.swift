import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractRegistrationPlaceAction: BasePresenter {
    func openContextMenu()
    func actionTapped()
    func openDetailedScreen(adressType: CriminalExtractAdressType)
}

final class CriminalExtractRegistrationPlacePresenter: CriminalExtractRegistrationPlaceAction {

	// MARK: - Properties
    unowned var view: CriminalExtractRegistrationPlaceView

    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let apiClient: CriminalExtractApiClientProtocol
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let bag = DisposeBag()
    private var requestModel: CriminalExtractRequestModel
    private var didRetry = false
    private var didRetryCountry = false
    private var regionDataSource: [CriminalExtractAdressSearchModel] = []
    private var districtDataSource: [CriminalExtractAdressSearchModel] = []
    private var cityDataSource: [CriminalExtractAdressSearchModel] = []
    
    private var currentRegion: CriminalExtractAdressSearchModel? {
        didSet {
            if currentRegion != oldValue && currentRegion != nil {
                currentDistrict = nil
                currentCity = nil
                districtDataSource = []
                cityDataSource = []
            }
            view.updateListElement(.region, model: currentRegion)
        }
    }
    
    private var currentDistrict: CriminalExtractAdressSearchModel? {
        didSet {
            if currentDistrict != oldValue && currentDistrict != nil {
                currentCity = nil
                cityDataSource = []
            }
            view.updateListElement(.district, model: currentDistrict)
        }
    }
    private var currentCity: CriminalExtractAdressSearchModel? {
        didSet {
            view.updateListElement(.city, model: currentCity)
        }
    }
    
    // MARK: - Init
    init(
        view: CriminalExtractRegistrationPlaceView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        apiClient: CriminalExtractApiClientProtocol,
        requestModel: CriminalExtractRequestModel,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.requestModel = requestModel
        self.apiClient = apiClient
        self.networkingContext = networkingContext
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setButtonState(.disabled)
        fetchRegistrationAdress(nil)
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped() {
        flowCoordinator.openNextScreen(
            screen: .contacts,
            model: requestModel,
            contextProvider: contextMenuProvider,
            networkingContext: networkingContext,
            in: view
        )
    }
    
    func openDetailedScreen(adressType: CriminalExtractAdressType) {
        let searchModel: [SearchModel]
        switch adressType {
        case .country:
            return
        case .region:
            searchModel = regionDataSource.map({ SearchModel(code: $0.id, title: $0.name) })
        case .district:
            searchModel = districtDataSource.map({ SearchModel(code: $0.id, title: $0.name) })
        case .city:
            searchModel = cityDataSource.map({ SearchModel(code: $0.id, title: $0.name) })
        }
        
        view.open(module: BaseSearchModule(items: searchModel, callback: { [weak self] model in
            self?.view.setButtonState(.disabled)
            let adressModel = CriminalExtractAdressSearchModel(model)
            switch adressType {
            case .country:
                break
            case .region:
                self?.currentRegion = adressModel
                self?.fetchRegistrationAdress(CriminalExtractAdressType.region.getRequestModel(adressModel))
            case .district:
                self?.currentDistrict = adressModel
                self?.fetchRegistrationAdress(CriminalExtractAdressType.district.getRequestModel(adressModel))
            case .city:
                self?.currentCity = adressModel
                self?.fetchRegistrationAdress(CriminalExtractAdressType.city.getRequestModel(adressModel))
            }
        }))
    }
    
    // MARK: - Private Methods
    private func fetchRegistrationAdress(_ model: CriminalExtractAdressRequestItem?) {
        view.setContextMenuAvailable(isAvailable: false)
        view.setLoadingState(.loading)
        apiClient
            .getRegistrationAdress(adressModel: model)
            .observe { [weak self] signal in
                guard let self = self else { return }
                self.view.setContextMenuAvailable(isAvailable: true)
                switch signal {
                case .next(let data):
                    switch data {
                    case .data(let response):
                        self.didRetry = false
                        self.handleResponse(data: response)
                    case .template(let template):
                        TemplateHandler.handleGlobal(template, callback: {_ in })
                    }
                case .failed(let error):
                    self.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchRegistrationAdress(model)
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleResponse(data: CriminalExtractAdressResponse) {
        if let adress = data.address {
            if currentDistrict == nil {
                view.setCurrentDistrictHidden(true)
            }
            if currentCity == nil {
                view.setCurrentCityHidden(true)
            }
            requestModel.registrationAddressId = adress.resourceId
            view.setButtonState(.solid)
        } else if let parameters = data.parameters?.first {
            view.configureCellText(parameters.type, label: parameters.label, hint: parameters.hint)
            
            switch parameters.type {
            case .country:
                if !didRetryCountry {
                    didRetryCountry.toggle()
                    fetchRegistrationAdress(
                        CriminalExtractAdressType.country.getRequestModel(
                            .Ukraine
                        )
                    )
                }
            default:
                let items = parameters.source.items
                switch parameters.type {
                case .region:
                    regionDataSource = items
                case .district:
                    districtDataSource = items
                case .city:
                    cityDataSource = items
                default: break
                }
            }
        }
        view.setLoadingState(.ready)
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
