import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractRegistrationPlaceView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(_ state: LoadingState)
    func updateListElement(_ type: CriminalExtractAdressType, model: CriminalExtractAdressSearchModel?)
    func setCurrentCityHidden(_ bool: Bool)
    func setCurrentDistrictHidden(_ bool: Bool)
    func setButtonState(_ state: LoadingStateButton.LoadingState)
    func configureCellText(_ type: CriminalExtractAdressType, label: String, hint: String)
}

final class CriminalExtractRegistrationPlaceViewController: UIViewController {

	// MARK: - Outlets
    @IBOutlet private weak var topView: TopNavigationView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var listStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var regionRegistrationCell: CriminalExtractRegistrationInputView!
    @IBOutlet private weak var districtRegistrationCell: CriminalExtractRegistrationInputView!
    @IBOutlet private weak var cityRegistrationCell: CriminalExtractRegistrationInputView!
    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    
	// MARK: - Properties
	var presenter: CriminalExtractRegistrationPlaceAction!

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        return view
    }()
    
	// MARK: - Init
	init() {
        super.init(nibName: CriminalExtractRegistrationPlaceViewController.className, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }

    private func initialSetup() {
        setupTopView()
        setupFonts()
        setupBackgroundView()
        setupButtons()
    }
    
    private func setupTopView() {
        titleLabel.text = R.Strings.driver_license_replacement_registration.localized()
        subTitleLabel.text = R.Strings.address_registration_select_subtitle.localized()
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.detailsTitleFont
        subTitleLabel.font = FontBook.usualFont
    }
    
    private func setupBackgroundView() {
        listStackView.insertSubview(backgroundView, at: .zero)
        backgroundView.fillSuperview()
    }
    
    private func setupButtons() {
        actionButton.setLoadingState(.solid, withTitle: R.Strings.general_next.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.contentEdgeInsets = Constants.buttonInsets
        actionButtonBottomConstraint.constant = AppConstants.Layout.buttonBottomOffset
    }
    
    // MARK: - Actions
    @IBAction private func actionTapped() {
        presenter.actionTapped()
    }
}

// MARK: - View logic
extension CriminalExtractRegistrationPlaceViewController: CriminalExtractRegistrationPlaceView {
    func updateListElement(_ type: CriminalExtractAdressType, model: CriminalExtractAdressSearchModel?) {
        let text = model?.name
        switch type {
        case .country:
            return
        case .region:
            regionRegistrationCell.setValueText(string: text)
            setCurrentDistrictHidden(false)
            setCurrentCityHidden(true)
        case .district:
            districtRegistrationCell.setValueText(string: text)
            if text != nil {
                setCurrentCityHidden(false)
            }
        case .city:
            cityRegistrationCell.setValueText(string: text)
        }
    }
    
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
    }
    
    func setLoadingState(_ state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        contentView.isHidden = state == .loading
    }
    func setCurrentCityHidden(_ bool: Bool) {
        cityRegistrationCell.isHidden = bool
    }
    
    func setCurrentDistrictHidden(_ bool: Bool) {
        districtRegistrationCell.isHidden = bool
    }
    
    func setButtonState(_ state: LoadingStateButton.LoadingState) {
        actionButton.setLoadingState(state)
    }
    
    func configureCellText(_ type: CriminalExtractAdressType, label: String, hint: String) {
        switch type {
        case .region:
            regionRegistrationCell.setTitle(
                title: label,
                placeholder: hint
            ) { [weak self] in
                self?.presenter.openDetailedScreen(adressType: .region)
            }
        case .district:
            districtRegistrationCell.setTitle(
                title: label,
                placeholder: hint
            ) { [weak self] in
                self?.presenter.openDetailedScreen(adressType: .district)
            }
        case .city:
            cityRegistrationCell.setTitle(
                title: label,
                placeholder: hint
            ) { [weak self] in
                self?.presenter.openDetailedScreen(adressType: .city)
            }
        default:
            break
        }
    }
}

// MARK: - Constants
extension CriminalExtractRegistrationPlaceViewController {
    private enum Constants {
        static let screenCode = "registrationPlaceSelection"
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
    }
}

extension CriminalExtractRegistrationPlaceViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}
