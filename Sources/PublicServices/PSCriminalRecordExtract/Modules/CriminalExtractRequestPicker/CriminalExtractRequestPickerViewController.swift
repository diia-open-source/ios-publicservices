import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractRequestPickerView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func actionButtonDidBecomeActive()
    func actionButtonDidBecomeInactve()
    func setState(state: LoadingState)
    func configureViews(vm: CriminalCertificatesRequestPickerViewModel)
}

final class CriminalExtractRequestPickerViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var actionButton: VerticalRoundButton!
    @IBOutlet weak private var pickerTypeLabel: UILabel!
    @IBOutlet weak private var pickerSubtitleLabel: UILabel!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var contentScrollView: UIScrollView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var gradientView: UIView!
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            Constants.startGradientColor,
            Constants.endGradientColor
        ]
        gradient.locations = [0, 1]
        gradient.frame = gradientView.bounds
        return gradient
    }()
    
    private var checkBoxes: [CheckmarkViewWithDescription] = []
    
	// MARK: - Properties
	var presenter: CriminalExtractRequestPickerAction!
    
    // MARK: - Init
    init() {
        super.init(nibName: CriminalExtractRequestPickerViewController.className, bundle: Bundle.module)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSeparatorVisibility()
    }
    
    // MARK: - private methods
    private func initialSetup() {
        setUpTopView()
        setUpButton()
        setUpUI()
        contentScrollView.delegate = self
    }
    
    private func setUpTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setUpButton() {
        actionButton.setTitle(R.Strings.general_next.localized(), for: .normal)
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.backgroundColor = .black.withAlphaComponent(0.1)
        actionButton.isUserInteractionEnabled = false
        actionButton.contentEdgeInsets = Constants.actionButtonInsets
    }
    
    private func setUpUI() {
        pickerTypeLabel.font = FontBook.detailsTitleFont
        pickerSubtitleLabel.font = FontBook.usualFont
        gradientView.layer.addSublayer(gradient)
    }
    
    private func updateSeparatorVisibility() {
        let contentHeight = Int(contentScrollView.contentSize.height)
        let fullOffset = Int(contentScrollView.contentOffset.y + contentScrollView.frame.height)
        let bool = contentHeight <= fullOffset
        gradientView.isHidden = bool
        separatorView.isHidden = bool
    }
    
    // MARK: - @IBActions
    @IBAction func didTapActionButton(_ sender: Any) {
        presenter.didTapActionButton()
    }
}

// MARK: - View logic
extension CriminalExtractRequestPickerViewController: CriminalExtractRequestPickerView {
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(
            callback: isAvailable
            ? { [weak self] in self?.presenter.openContextMenu() }
            : nil
        )
    }
    
    func actionButtonDidBecomeActive() {
        actionButton.backgroundColor = .black.withAlphaComponent(1)
        actionButton.isUserInteractionEnabled = true
    }
    
    func actionButtonDidBecomeInactve() {
        actionButton.backgroundColor = .black.withAlphaComponent(0.1)
        actionButton.isUserInteractionEnabled = false
    }
    
    func setState(state: LoadingState) {
        contentScrollView.isHidden = state == .loading
        topView.setupLoading(isActive: state == .loading)
        actionButton.isHidden = state == .loading
        separatorView.isHidden = state == .loading
    }
    
    func configureViews(vm: CriminalCertificatesRequestPickerViewModel) {
        self.pickerTypeLabel.text = vm.typeText
        self.pickerSubtitleLabel.text = vm.typeSubtitle
        
        checkBoxes.forEach { checkBox in
            checkBox.removeFromSuperview()
        }
        
        for item in vm.items {
            
            let checkbox = CheckmarkViewWithDescription(frame: CGRect.zero)
            checkbox.setUp(id: item.code,
                           title: item.title,
                           description: item.description)
            checkbox.delegate = self
            self.checkBoxes.append(checkbox)
            self.stackView.addArrangedSubview(checkbox)
        }
        stackView.customize(backgroundColor: .white, radiusSize: Constants.listCornerRadius)
        view.layoutIfNeeded()
    }
}

// MARK: - CheckmarkViewWithDescriptionDelegate
extension CriminalExtractRequestPickerViewController: CheckmarkViewWithDescriptionDelegate {
    func didSelect(id: String) {
        presenter.didSelectItem(id: id)
        for item in checkBoxes {
            item.toggleCheck(status: item.id == id)
        }
    }
}

// MARK: - Constants
extension CriminalExtractRequestPickerViewController {
    struct Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
        static let actionButtonInsets: UIEdgeInsets = .init(top: 16, left: 62, bottom: 16, right: 62)
        static let listCornerRadius = 8.0
        static let startGradientColor = UIColor(hex6: 0xE2ECF4, alpha: 0.0).cgColor
        static let endGradientColor = UIColor(hex6: 0xE2ECF4, alpha: 1.0).cgColor
    }
}

private extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension CriminalExtractRequestPickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSeparatorVisibility()
    }
}

extension CriminalExtractRequestPickerViewController: RatingFormHolder {
    func screenCode() -> String {
        return presenter.screenCode()
    }
}
