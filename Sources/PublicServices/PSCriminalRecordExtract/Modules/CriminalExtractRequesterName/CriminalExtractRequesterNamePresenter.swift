import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

protocol CriminalExtractRequesterNameAction: BasePresenter {
    typealias ViewModel = CriminalExtractRequestedNameViewModel
    var title: String { get }
    var fullName: LabelValueModel { get }
    var parametrizedMessage: ParameterizedAttentionMessage? { get }
    func viewModelForIndex(index: Int) -> ViewModel
    func openContextMenu()
    func actionTapped()
}

final class CriminalExtractRequesterNamePresenter: CriminalExtractRequesterNameAction {
    
    // MARK: - Public properties
    
    var title: String {
        _title
    }
    
    var fullName: LabelValueModel {
        _fullName
    }
    
    var parametrizedMessage: ParameterizedAttentionMessage? {
        _parametrizedMessage
    }
    
	// MARK: - Private Properties
   
    unowned var view: CriminalCertificateRequesterNameView

    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let apiClient: CriminalExtractApiClientProtocol
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let bag = DisposeBag()
    private var requestModel: CriminalExtractRequestModel
    private var didRetry = false
    private var _title: String = .empty
    private var _fullName: LabelValueModel = LabelValueModel(label: .empty, value: .empty)
    private var _parametrizedMessage: ParameterizedAttentionMessage?
    private var dataSource: [[String]] = [[], [], []]
    private var maxCount = 10
    private var nextScreen: CriminalExtractScreen?
    
    // MARK: - Init
    init(
        view: CriminalCertificateRequesterNameView,
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
        fetchStatus()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped() {
        guard let nextScreen = nextScreen else { return }
        
        let lastName = dataSource[0]
            .filter({ $0.isEmpty == false })
            .joined(separator: ", ")
        
        let firstName = dataSource[1]
            .filter({ $0.isEmpty == false })
            .joined(separator: ", ")
        let middleName = dataSource[2]
            .filter({ $0.isEmpty == false })
            .joined(separator: ", ")
        
        requestModel.previousFirstName = !firstName.isEmpty ? firstName : nil
        requestModel.previousMiddleName = !middleName.isEmpty ? middleName : nil
        requestModel.previousLastName = !lastName.isEmpty ? lastName : nil
        
        flowCoordinator.openNextScreen(
            screen: nextScreen,
            model: requestModel,
            contextProvider: contextMenuProvider,
            networkingContext: networkingContext,
            in: view
        )
    }
    
    func viewModelForIndex(index: Int) -> ViewModel {
        return ViewModel(
            values: dataSource[index].map({ dataSourceItem(string: $0)}),
            isEnabledAdding: isEnabledAdding(index: index),
            updateAction: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .add:
                    if self.isEnabledAdding(index: index) {
                        self.dataSource[index].append(.empty)
                        self.view.updateTableView(row: index)
                    }
                case .editing(oldValue: let oldValue, newValue: let newValue):
                    if let elementIndex = self.dataSource[index].firstIndex(where: { $0 == oldValue}) {
                        self.dataSource[index][elementIndex] = newValue
                        self.view.setActionButtonActive(self.validateData())
                    }
                case .finishedEditing(oldValue: let oldValue, newValue: let newValue):
                    if let elementIndex = self.dataSource[index].firstIndex(where: { $0 == oldValue}) {
                        self.dataSource[index][elementIndex] = newValue
                        self.view.setActionButtonActive(self.validateData())
                        self.view.updateTableView(row: index)
                    }
                case .remove(value: let value):
                    if let elementIndex = self.dataSource[index].firstIndex(of: value) {
                        self.dataSource[index].remove(at: elementIndex)
                        self.view.setActionButtonActive(self.validateData())
                    }
                }
            }
        )
    }

    // MARK: - Private Methods
   
    private func isEnabledAdding(index: Int) -> Bool {
        guard dataSource[index].count < maxCount else { return false }
        return !(dataSource[index].contains(.empty) && !dataSource[index].isEmpty)
    }
    
    private func validateData() -> Bool {
        for array in dataSource {
            for element in array where !element.isEmpty {
                if !isValid(string: element) {
                    return false
                }
            }
        }
        return true
    }
    
    private func dataSourceItem(string: String) -> (value: String, isValid: Bool) {
        let isValid = isValid(string: string) || string.isEmpty
        return (value: string, isValid: isValid)
    }
    
    @discardableResult
    private func isValid(string: String) -> Bool {
        let literalRegex = #"^[А-ЩЬЮЯҐЄІЇа-щьюяґєії \x{2019} ʼ [:punct:]]{1,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", literalRegex)
        return test.evaluate(with: string)
    }
    
    private func fetchStatus() {
        view.setLoadingState(.loading)
        apiClient
            .getRequester()
            .observe { [weak self] signal in
                switch signal {
                case .next(let data):
                    self?.view.setContextMenuAvailable(isAvailable: true)
                    self?.didRetry = false
                    self?.handleResponse(data: data)
                case .failed(let error):
                    self?.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchStatus()
                        })
                default: break
                }
            }
            .dispose(in: bag)
    }
    
    private func handleResponse(data: CriminalExtractRequesterResponse) {
        if let response = data.requesterDataScreen {
            nextScreen = response.nextScreen
            _title = response.title
            _fullName = response.fullName
            _parametrizedMessage = response.attentionMessage
            view.setLoadingState(.ready)
        } else if let template = data.template {
            TemplateHandler.handle(template, in: view, callback: { [weak self] action in
                if action == .criminalRecordCertificate {
                    self?.view.closeModule(animated: true)
                }
            })
        }
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
