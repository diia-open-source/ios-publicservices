import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractIntroView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(_ state: LoadingState)
    func configureStartScreen(model: CertificateIntroModel)
}

final class CriminalExtractIntroViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var startView: StartServiceView!
    @IBOutlet weak private var actionButton: LoadingStateButton!
    @IBOutlet weak private var actionButtonBottomConstrait: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: CriminalExtractIntroAction!
    
    // MARK: - Init
    init() {
        super.init(nibName: CriminalExtractIntroViewController.className, bundle: Bundle.module)
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
        setupTopView()
        setupButton()
    }
    
    private func setupTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupButton() {
        actionButton.setLoadingState(.solid, withTitle: R.Strings.criminal_certificate_request_intro_action_button.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.contentEdgeInsets = Constants.actionButtonInsets
        actionButtonBottomConstrait.constant = AppConstants.Layout.buttonBottomOffset
    }
    
    @IBAction private func didTapActionButton(_ sender: Any) {
        presenter.didTapActionButton()
    }
}

// MARK: - View logic
extension CriminalExtractIntroViewController: CriminalExtractIntroView {
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(
            callback: isAvailable
            ? { [weak self] in self?.presenter.openContextMenu() }
            : nil
        )
    }
    
    func setLoadingState(_ state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        contentView.isHidden = state == .loading
    }
    
    func configureStartScreen(model: CertificateIntroModel) {
        startView.set(urlOpener: PackageConstants.urlOpener)

        if let title = model.title {
            startView.configure(greetings: title, info: model.text ?? .empty)
        }
        
        if let message = model.attentionMessage {
            actionButton.isHidden = true
            startView.configureAttention(attention: message)
        } else { actionButton.isHidden = false }
        startView.isHidden = false
    }
}

// MARK: - Constants
extension CriminalExtractIntroViewController {
    struct Constants {
        static let screenCode = "start"
        static let horizontalInset: CGFloat = 24.0
        static let progressAnimationDuration: TimeInterval = 1.5
        static let actionButtonInsets: UIEdgeInsets = .init(top: 16, left: 51, bottom: 16, right: 51)
    }
}

extension CriminalExtractIntroViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}
