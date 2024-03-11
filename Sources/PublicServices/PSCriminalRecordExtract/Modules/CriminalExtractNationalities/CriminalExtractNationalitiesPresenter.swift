import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

protocol CriminalExtractNationalitiesAction: BasePresenter {
    typealias ViewModel = CriminalExtractNationalitiesViewModel
    func openContextMenu()
    func actionTapped()
    func viewModelForСell() -> ViewModel
    func attentionMessageForCell() -> ParameterizedAttentionMessage
}

final class CriminalExtractNationalitiesPresenter: CriminalExtractNationalitiesAction {

    typealias ViewModel = CriminalExtractNationalitiesViewModel
    
	// MARK: - Properties
    unowned var view: CriminalExtractNationalitiesView

    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private var requestModel: CriminalExtractRequestModel
    private let apiClient: CriminalExtractApiClientProtocol
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let bag = DisposeBag()
    private var didRetry = false
    private var nationalities: [SearchModel?] = [nil]
    private var items: [SearchModel] = []
    private var maxCount = Constants.defaultMaxCount
    private var nextScreen: CriminalExtractScreen?
    private var attentionMessage = ParameterizedAttentionMessage(title: nil,
                                                                 text: R.Strings.criminal_extract_nationalities_description.localized(),
                                                                 icon: "☝️",
                                                                 parameters: nil)
    
    private var isExpandable: Bool {
        if !nationalities.compactMap({$0}).isEmpty && nationalities.count < maxCount {
            for nation in nationalities.compactMap({$0}) where nation.code == Constants.UkraineModel.code {
                    return false
                }
        } else { return false }
        return true
    }
    
    // MARK: - Init
    init(
        view: CriminalExtractNationalitiesView,
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
        validate()
        fetchNationalities()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped() {
        guard let screen = nextScreen else { return }
        requestModel.nationalities = Array(
            Set(nationalities.compactMap({ $0?.title}))
        )
        
        flowCoordinator.openNextScreen(
            screen: screen,
            model: requestModel,
            contextProvider: contextMenuProvider,
            networkingContext: networkingContext,
            in: view
        )
    }
    
    func attentionMessageForCell() -> ParameterizedAttentionMessage {
        return attentionMessage
    }
    
    func viewModelForСell() -> ViewModel {
        return ViewModel(
            nationalities: nationalities.map({ $0?.title}),
            isExpandable: isExpandable
        ) { [weak self] action in
            switch action {
            case .add:
                guard let self = self else { return }
                if self.nationalities.count >= self.maxCount { return }
                self.nationalities.append(nil)
                self.view.updateTableView()
            case .edit(let index):
                self?.openSearchModule(index: index)
            case .remove(let index):
                self?.nationalities.remove(at: index)
                self?.view.updateTableView()
            }
            self?.validate()
        }
    }
    
    // MARK: - Private Methods
    
    private func openSearchModule(index: Int) {
        view.open(
            module: BaseSearchModule(
                items: getUniqueSearchModels(index: index)
            ) { [weak self] model in
                self?.nationalities[index] = model
                self?.view.updateTableView()
                self?.validate()
        })
    }
    
    private func validate() {
        view.setActionButtonActive(!nationalities.compactMap({$0}).isEmpty)
    }
    
    private func getUniqueSearchModels(index: Int) -> [SearchModel] {
        var itemsToRemove =  nationalities.compactMap({$0})
        if itemsToRemove.isEmpty {
            return items
        } else if nationalities.count > 1 {
            itemsToRemove.append(Constants.UkraineModel)
        }
        switch index {
        case .zero:
            return items.filter({ item in !itemsToRemove.contains(where: { $0.code == item.code }) })
        default:
            itemsToRemove.append(Constants.UkraineModel)
            return items.filter({ item in !itemsToRemove.contains(where: { $0.code == item.code }) })
        }
    }
    
    private func fetchNationalityStatus() {
        apiClient
            .fetchNationalityStatus()
            .observe { [weak self] result in
                switch result {
                case .next(let data):
                    if let response = data.nationalitiesScreen {
                        self?.handleStatusResponse(response)
                    } else if let template = data.template {
                        self?.handleTemplate(template)
                    }
                case .failed(let error):
                    self?.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchNationalityStatus()
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleStatusResponse(_ response: CriminalExtractNationalitiesScreenResponse) {
        didRetry = false
        view.setContextMenuAvailable(isAvailable: true)
        view.setLoadingState(.ready)
        maxCount = response.maxNationalitiesCount
        nextScreen = response.nextScreen
        attentionMessage = response.attentionMessage
        view.setActionButtonActive(false)
        view.updateTableView()
    }
    
    private func fetchNationalities() {
        view.setLoadingState(.loading)
        apiClient
            .getNationalities()
            .observe { [weak self] signal in
                switch signal {
                case .next(let data):
                    switch data {
                    case .data(let response):
                        self?.didRetry = false
                        self?.items = response.nationalities.map({ SearchModel(code: $0.code, title: $0.name)})
                        self?.fetchNationalityStatus()
                    case .template(let template):
                        self?.handleTemplate(template)
                    }
                case .failed(let error):
                    self?.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchNationalities()
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleTemplate(_ template: AlertTemplate) {
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

extension CriminalExtractNationalitiesPresenter {
    enum Constants {
        static let UkraineModel: SearchModel = SearchModel(code: "804", title: "УКРАЇНА")
        static let defaultMaxCount = 2
    }
}
