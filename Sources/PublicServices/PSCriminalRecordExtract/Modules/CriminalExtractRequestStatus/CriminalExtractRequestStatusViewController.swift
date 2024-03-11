import UIKit
import QuickLook
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractRequestStatusView: BaseView {
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol)
    func configureScreen(vm: CriminalExtractStatusModel)
    func setState(state: LoadingState)
    func downloadDocument(by path: URL)
    func previewFile(by path: URL)
    func updateDownloadViewModelState(isLoading: Bool)
    func updatePreviewViewModelState(isLoading: Bool)
}

final class CriminalExtractRequestStatusViewController: UIViewController {
    
    // MARK: - Private @IBOutlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var pageTitleLabel: UILabel!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var emojiLabel: UILabel!
    @IBOutlet weak private var statusTitleLabel: UILabel!
    @IBOutlet weak private var statusDescriptionLabel: UILabel!
    @IBOutlet weak private var statusContainerView: UIView!
    @IBOutlet weak private var actionContainer: UIView!
    @IBOutlet weak private var actionContainerStackView: UIStackView!
    
    // MARK: - Properties
    var screenState: CriminalCertStatusScreenType = .pendig
    var presenter: CriminalExtractRequestStatusAction!

    private var downloadArchiveVM: IconedLoadingStateViewModel?
    private var previewPdfVM: IconedLoadingStateViewModel?
    
    private var fileURL: URL?
    
    // MARK: - Init
    init() {
        super.init(nibName: CriminalExtractRequestStatusViewController.className, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        presenter.configureView()
    }

    // MARK: - private methods
    private func initialSetup() {
        setUpTopView()
        setUpFonts()
        setUpUI()
    }
    
    private func setUpTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.presenter.didTapBackButton()
        })
    }

    private func setUpFonts() {
        pageTitleLabel.font = FontBook.cardsHeadingFont
        emojiLabel.font = FontBook.smallHeadingFont
        statusTitleLabel.font = FontBook.bigText
        statusDescriptionLabel.font = FontBook.usualFont
    }

    private func setUpUI() {
        statusContainerView.layer.cornerRadius = Constants.radius
        statusContainerView.layer.masksToBounds = true
        actionContainer.layer.cornerRadius = 8.0
        actionContainer.layer.borderColor = UIColor(hex: 0xC9D8E7).cgColor
        actionContainer.layer.borderWidth = 2.0
        actionContainer.layoutSubviews()
    }

    private func setupActions(loadActions: [CriminalExtractStatusLoadAction]) {
        loadActions.forEach({ action in
            let image: UIImage
            let onClick: Callback
            switch action.type {
            case .downloadArchive:
                image = R.Image.downloadIcon.image ?? UIImage()
                onClick = { [weak self] in
                    if let bool = self?.downloadArchiveVM?.isLoading,
                       bool { return }
                    self?.updateDownloadViewModelState(isLoading: true)
                    self?.presenter.didTapShareCertificate()
                }
            case .viewPdf:
                image = R.Image.eye.image ?? UIImage()
                onClick = { [weak self] in
                    if let bool = self?.previewPdfVM?.isLoading,
                       bool { return }
                    self?.updatePreviewViewModelState(isLoading: true)
                    self?.presenter.didTapViewCertificate()
                }
            }
            
            let iconedView = IconedLoadingStateView()
            let viewModel = IconedLoadingStateViewModel(
                name: action.name,
                image: image,
                clickHandler: onClick
            )
            iconedView.configure(viewModel: viewModel)
            actionContainerStackView.addArrangedSubview(iconedView)
            
            if action.type == .viewPdf {
                previewPdfVM = viewModel
            } else {
                downloadArchiveVM = viewModel
            }
        })
    }
}

// MARK: - View logic
extension CriminalExtractRequestStatusViewController: CriminalExtractRequestStatusView {
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol) {
        topView.setupTitle(title: contextMenuProvider.title ?? "")
        topView.setupOnContext(callback: contextMenuProvider.hasContextMenu()
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
    }
    
    func updateDownloadViewModelState(isLoading: Bool) {
        downloadArchiveVM?.isLoading = isLoading
    }
    
    func updatePreviewViewModelState(isLoading: Bool) {
        previewPdfVM?.isLoading = isLoading
    }
    
    func downloadDocument(by path: URL) {
        let fileURL = path
        var filesToDownload = [Any]()
        filesToDownload.append(fileURL)
        let activityViewController = UIActivityViewController(activityItems: filesToDownload, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { [weak self] _, _, _, _ in
            self?.presenter.removeFileFromStorage(path: path)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: DispatchWorkItem(block: { [weak self] in
            self?.present(activityViewController, animated: true, completion: nil)
        }))
    }

    func previewFile(by path: URL) {
        updatePreviewViewModelState(isLoading: false)
        self.fileURL = path
        let previewController = QLPreviewController()
        previewController.setEditing(false, animated: true)
        previewController.dataSource = self
        previewController.delegate = self
        present(previewController, animated: true)
    }

    func setState(state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        stackView.isHidden = state == .loading
        statusContainerView.isHidden = state == .loading
        if state == .loading {
            actionContainer.isHidden = true
        }
    }

    func configureScreen(vm: CriminalExtractStatusModel) {
        pageTitleLabel.text = vm.title
        emojiLabel.text = vm.statusMessage?.icon
        statusTitleLabel.text = vm.statusMessage?.title
        statusDescriptionLabel.text = vm.statusMessage?.text
        if let loadActions = vm.loadActions {
            actionContainer.isHidden = false
            setupActions(loadActions: loadActions)
        } else { actionContainer.isHidden = true }
    }
}

// MARK: - Constants
extension CriminalExtractRequestStatusViewController {
    struct Constants {
        static let screenCode = "status"
        static let radius: CGFloat = 8.0
        static let actionButtonInsets: UIEdgeInsets = .init(top: 16, left: 51, bottom: 16, right: 51)
    }
}

extension CriminalExtractRequestStatusViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}

extension CriminalExtractRequestStatusViewController: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let url = self.fileURL else {
            fatalError("Could not load file")
        }

        return url as QLPreviewItem
    }

    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        guard let url = self.fileURL else {
            return
        }

        presenter.removeFileFromStorage(path: url)
    }
}
