import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaNetwork
import DiiaUIComponents
import DiiaCommonTypes
import DiiaCommonServices

protocol CriminalExtractRequestStatusAction: BasePresenter {
    func didTapShareCertificate()
    func didTapViewCertificate()
    func openContextMenu()
    func getScreenTitle() -> String?
    func didTapBackButton()
    func removeFileFromStorage(path: URL)
}

final class CriminalExtractRequestStatusPresenter: CriminalExtractRequestStatusAction {
    // MARK: - private properties
    private let apiClient: CriminalExtractApiClientProtocol
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: CriminalExtractCoordinator
    private let screenType: CriminalCertStatusScreenType
    private let networkingContext: PSCriminalRecordExtractNetworkingContext
    private let disposebag = DisposeBag()
    private var didRetry = false
    private var didRetryGetCertificate = false
    private let needToReplaceRootWithList: Bool
    private let applicationId: String

    // MARK: - Public properties
    unowned var view: CriminalExtractRequestStatusView

    var date: String = ""

    var documentName: String {
        return "\(Constants.criminalDocumentNamePrefix)\(date).\(Constants.pdfSufix)"
    }

    var archiveName: String {
        return "\(Constants.criminalDocumentNamePrefix)\(date).\(Constants.archiveSufix)"
    }

    // MARK: - Initialization
    init(
        view: CriminalExtractRequestStatusView,
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: CriminalExtractCoordinator,
        screenType: CriminalCertStatusScreenType,
        apiClient: CriminalExtractApiClientProtocol,
        applicationId: String,
        documentDate: String?,
        needToReplaceRootWithList: Bool,
        networkingContext: PSCriminalRecordExtractNetworkingContext
    ) {
        self.apiClient = apiClient
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.view = view
        self.screenType = screenType
        self.applicationId = applicationId
        self.needToReplaceRootWithList = needToReplaceRootWithList
        self.date = documentDate ?? "YYYY.MM.DD"
        self.networkingContext = networkingContext
    }

    func configureView() {
        view.setupHeader(contextMenuProvider: contextMenuProvider)
        loadInfo()
    }

    // MARK: - Private Methods
    private func loadInfo() {
        self.view.setState(state: .loading)
        apiClient
            .getStatus(applicationId: applicationId)
            .observe { [weak self] signal in
                guard let self = self else { return }
                switch signal {
                case .next(let response):
                    self.handleResponse(response)
                case .failed(let error):
                    self.handleError(error: error) { [weak self] in
                        self?.loadInfo()
                    }
                    
                default:
                    break
                }
            }
            .dispose(in: disposebag)
    }
    
    private func handleResponse(_ response: TemplatedResponse<CriminalExtractStatusModel>) {
        switch response {
        case .data(let model):
            if let navigationPanel = model.navigationPanel {
                contextMenuProvider.setTitle(title: navigationPanel.header)
                contextMenuProvider.setContextMenu(items: navigationPanel.contextMenu)
                view.setupHeader(contextMenuProvider: contextMenuProvider)
            }
            handleData(model)
        case .template(let template):
            handleTemplate(template: template)
        }
    }
    
    private func handleData(_ data: CriminalExtractStatusModel) {
        self.view.configureScreen(vm: data)
        self.view.setState(state: .ready)
        if let form = data.ratingForm {
            PackageConstants.ratingServiceOpener?.ratePublicServiceByRequest(publicServiceType: PackageConstants.packageServiceType,
                                                                             form: form,
                                                                             successCallback: { [weak self] template in
                self?.handleTemplate(template: template)
            },
                                                                             in: self.view)
        }
    }

    private func handleError(error: NetworkError, retryCallback: @escaping Callback) {
        GeneralErrorsHandler.process(error: .serverError, with: retryCallback, didRetry: didRetry, in: view)
        didRetry = true
    }

    private func saveFileToStorage(_ base64String: String, documentName: String) -> URL? {
        guard
        var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
            let convertedData = Data(base64Encoded: base64String)
            else {
            return nil
        }
        documentsURL.appendPathComponent(documentName)

        do {
            try convertedData.write(to: documentsURL)
        } catch {
            log("Could not save file to directory by reason: \(error.localizedDescription)")
        }

        return documentsURL
    }

    func removeFileFromStorage(path: URL) {
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            log("Could not remove file at directory by reason: \(error.localizedDescription)")
        }
    }

    private func saveAndShareFile(_ base64String: String, documentName: String) {
        if let url = self.saveFileToStorage(base64String, documentName: documentName) {
            self.view.downloadDocument(by: url)
        }
    }

    private func openFileToView(_ base64String: String, documentName: String) {
        if let url = self.saveFileToStorage(base64String, documentName: documentName) {
            self.view.previewFile(by: url)
        }
    }
    
    private func handleResponse(response: TemplatedResponse<CertificateFileToShareModel>, handler: @escaping (String) -> Void) {
        switch response {
        case .data(let model):
            handler(model.file)
        case .template(let template):
            handleTemplate(template: template)
        }
    }
    
    private func getCertificateToShare(handler: @escaping (String) -> Void) {
        self.apiClient
            .getFileToShare(applicationId: self.applicationId)
            .observe { [weak self] signal in
            guard let self = self else { return }

            switch signal {
            case .next(let response):
                self.view.updateDownloadViewModelState(isLoading: false)
                self.handleResponse(response: response, handler: handler)
            case .failed(let error):
                self.handleError(error: error) { [weak self] in
                    guard let self = self else { return }
                    self.view.updateDownloadViewModelState(isLoading: false)
                    if !self.didRetryGetCertificate {
                        self.getCertificateToShare(handler: handler)
                        self.view.updateDownloadViewModelState(isLoading: true)
                    }
                    self.didRetryGetCertificate = true
                }

            default:
                break
            }
        }
            .dispose(in: disposebag)
    }

    private func getCertificateToView(handler: @escaping (String) -> Void) {
        self.apiClient
            .getFileToView(applicationId: self.applicationId)
            .observe { [weak self] signal in
            guard let self = self else { return }

            switch signal {
            case .next(let response):
                self.view.updatePreviewViewModelState(isLoading: false)
                self.handleResponse(response: response, handler: handler)
            case .failed(let error):
                self.handleError(error: error) { [weak self] in
                    guard let self = self else { return }
                    self.view.updatePreviewViewModelState(isLoading: false)
                    if !self.didRetryGetCertificate {
                        self.getCertificateToView(handler: handler)
                        self.view.updatePreviewViewModelState(isLoading: true)
                    }
                    self.didRetryGetCertificate = true
                }

            default:
                break
            }
        }
            .dispose(in: disposebag)
    }

    // MARK: - Implementation
    func didTapViewCertificate() {
        self.getCertificateToView { [weak self] file in
            guard let self = self else { return }
            self.openFileToView(file, documentName: self.documentName)
        }
    }

    func didTapShareCertificate() {
        self.getCertificateToShare { [weak self] file in
            guard let self = self else { return }
            self.saveAndShareFile(file, documentName: self.archiveName)
        }
    }
    
    func didTapBackButton() {
        if needToReplaceRootWithList,
           let ratingServiceOpener = PackageConstants.ratingServiceOpener,
           let urlOpener = PackageConstants.urlOpener {
            flowCoordinator.replaceRoot(with: CriminalExtractListModule(
                contextMenuProvider: contextMenuProvider,
                flowCoordinator: flowCoordinator,
                preselectedType: .applicationProcessing,
                сonfig: .init(ratingServiceOpener: ratingServiceOpener,
                              networkingContext: networkingContext,
                              urlOpener: urlOpener)
            ), animated: true)
        } else {
            view.closeModule(animated: true)
        }
    }

    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }

    func getScreenTitle() -> String? {
        return R.Strings.criminal_certificate_request_home_title.localized()
    }
    
    private func handleTemplate(template: AlertTemplate) {
        TemplateHandler.handle(template, in: view, callback: { [weak self] action in
            if action == .skip {
                self?.view.closeModule(animated: true)
            }
        })
    }
}

extension CriminalExtractRequestStatusPresenter {
    struct Constants {
        static let criminalDocumentNamePrefix: String = R.Strings.criminal_extract_result_document_name.localized()
        static let pdfSufix: String = "pdf"
        static let archiveSufix: String = "zip"
    }
}
