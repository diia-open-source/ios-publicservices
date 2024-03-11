import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractRequestResultView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func actionButtonDidBecomeActive()
    func actionButtonDidBecomeInactve()
    func setState(state: LoadingState)
    func configureViews(vm: CriminalExtractNewConfirmationModel)
    func setLoadingState(_ state: LoadingStateButton.LoadingState, title: String)
}

final class CriminalExtractRequestResultViewController: UIViewController {
    
    // MARK: - Private @IBOutlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var actionButton: LoadingStateButton!
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var pageTitleLabel: UILabel!
    @IBOutlet weak private var alertContainerView: UIView!
    @IBOutlet weak private var stackViewTitleLabel: UILabel!
    @IBOutlet weak private var checkBoxView: CheckmarkViewWithDescription!
    @IBOutlet weak private var contactDataLabel: UILabel!
    @IBOutlet weak private var goalLabel: UILabel!
    @IBOutlet weak private var goalValue: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var typeValue: UILabel!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var contactDataStackView: UIStackView!
    @IBOutlet weak private var bottomContainerView: UIView!
    
    // MARK: - Private Properties
    private var viewModel: CriminalExtractResultViewModel?
    
	// MARK: - Public Properties
	var presenter: CriminalExtractRequestResultAction!
    
    // MARK: - Init
    init() {
        super.init(nibName: CriminalExtractRequestResultViewController.className, bundle: Bundle.module)
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
        setUpTitles()
        setUpFonts()
        setUpUI()
    }
    
    private func setUpTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setUpTitles() {
        stackViewTitleLabel.text = R.Strings.criminal_certificate_request_result_stack_view_title.localized()
        pageTitleLabel.text = R.Strings.criminal_certificate_request_set_contacts_page_title.localized()
        actionButton.setTitle(R.Strings.general_send.localized(), for: .normal)
        contactDataLabel.text = R.Strings.fop_contacts_title.localized()
        goalLabel.text = R.Strings.criminal_certificate_request_request_goal_result.localized()
        typeLabel.text = R.Strings.criminal_extract_result_type_title.localized()
    }
    
    private func setUpFonts() {
        pageTitleLabel.font = FontBook.detailsTitleFont
        actionButton.titleLabel?.font = FontBook.bigText
        
        [stackViewTitleLabel, contactDataLabel, goalLabel, typeLabel].forEach { label in
            label?.font = FontBook.smallHeadingFont
        }
        
        [goalValue, typeValue].forEach { label in
            label?.font = FontBook.usualFont
        }
    }
    
    private func setUpUI() {
        actionButton.backgroundColor = .black.withAlphaComponent(0.1)
        actionButton.isUserInteractionEnabled = false
        bottomContainerView.layer.cornerRadius = 8.0
        bottomContainerView.withBorder(width: 1.0, color: .emptyDocumentsBackground)
    }
    
    // MARK: - @IBActions
    @IBAction func didTapActionButton(_ sender: Any) {
        presenter.didTapActionButton()
    }
}

// MARK: - View logic
extension CriminalExtractRequestResultViewController: CriminalExtractRequestResultView {
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
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
        topView.setupLoading(isActive: state == .loading)
        scrollView.isHidden = state == .loading
    }
    
    func setLoadingState(_ state: LoadingStateButton.LoadingState, title: String) {
        actionButton.setLoadingState(state, withTitle: title)
    }
    
    func configureViews(vm: CriminalExtractNewConfirmationModel) {
        guard let viewModel = presenter.geContactViewModel() else { return }
        self.viewModel = viewModel
        pageTitleLabel.text = vm.application.title
        let alertView: AttentionView = AttentionView()
        alertView.configure(
            title: vm.application.attentionMessage?.title,
            description: vm.application.attentionMessage?.text,
            emoji: vm.application.attentionMessage?.icon ?? ""
        )
        alertContainerView.addSubview(alertView)
        alertView.fillSuperview()
        checkBoxView.setUp(id: "1",
                           title: vm.application.checkboxName,
                           description: nil,
                           isChecked: false,
                           userRoundButton: false,
                           isSeparatorHidden: true
        )
        checkBoxView.checkMarkDelegate = self

        for item in CriminalExtractDataType.orderedKeys {
            let dataView = HorizontalDataWithTitleAndValueStackView()
            
            if let model = vm.getModelFor(item) {
                
                if item == .previousLastName || item == .previousFirstName || item == .previousSecondName {
                    let value = model.value.replacingOccurrences(of: ",", with: ",\n")
                    dataView.setUp(title: model.label, value: value)
                } else {
                    dataView.setUp(title: model.label, value: model.value)
                }
                stackView.addArrangedSubview(dataView)
            }
        }
        
        if let model = vm.getModelFor(.phoneNumber) {
            let contactDataView = HorizontalDataWithTitleAndValueStackView()
            contactDataView.setUp(title: model.label, value: model.value)
            contactDataStackView.addArrangedSubview(contactDataView)
        }
                
        typeValue.text = vm.application.certificateType.type
        goalValue.text = vm.application.reason.reason
    }
}

// MARK: - CheckBoxViewWithDescriptionDelegate
extension CriminalExtractRequestResultViewController: CheckBoxViewWithDescriptionDelegate {
    func didSelect(index: String, status: Bool) {
        guard let viewModel = self.viewModel else { return }
        viewModel.isChecked = status
        presenter.validateViewModel()
    }
}

// MARK: - Constants
extension CriminalExtractRequestResultViewController {
    struct Constants {
        static let screenCode = "application"
        static let horizontalInset: CGFloat = 24.0
        static let progressAnimationDuration: TimeInterval = 1.5
        static let alertViewHeight: CGFloat = 67.0
    }
}

extension CriminalExtractRequestResultViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}
