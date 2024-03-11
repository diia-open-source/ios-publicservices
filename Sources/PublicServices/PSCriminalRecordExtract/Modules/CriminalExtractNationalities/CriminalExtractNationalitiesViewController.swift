import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractNationalitiesView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(_ state: LoadingState)
    func updateTableView()
    func setActionButtonActive(_ bool: Bool)
}

final class CriminalExtractNationalitiesViewController: UIViewController {

    // TODO: should be reworked using UIStackView instead of UITableView
    
	// MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    
	// MARK: - Properties
	var presenter: CriminalExtractNationalitiesAction!

	// MARK: - Init
	init() {
        super.init(nibName: CriminalExtractNationalitiesViewController.className, bundle: Bundle.module)
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
        setupTableView()
        setupButtons()
    }
    
    private func setupTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(CriminalExtractNationalitiesCell.nib,
                           forCellReuseIdentifier: CriminalExtractNationalitiesCell.reuseID)
        tableView.register(CriminalExtractRequestNameMessageCell.nib,
                           forCellReuseIdentifier: CriminalExtractRequestNameMessageCell.reuseID)
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
extension CriminalExtractNationalitiesViewController: CriminalExtractNationalitiesView {
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
    }
    
    func setLoadingState(_ state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        contentView.isHidden = state == .loading
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func setActionButtonActive(_ bool: Bool) {
        actionButton.setLoadingState(bool ? .solid : .disabled)
    }
}

// MARK: - Constants
extension CriminalExtractNationalitiesViewController {
    private enum Constants {
        static let screenCode = "nationality"
        static let numberOfSections = 1
        static let numberOfRowsInSection = 2
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
        static let headerLabelOffset = CGPoint(x: 24, y: 24)
        static let headerHeight = 69.0
    }
}

extension CriminalExtractNationalitiesViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}

extension CriminalExtractNationalitiesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case .zero:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractRequestNameMessageCell.reuseID, for: indexPath) as? CriminalExtractRequestNameMessageCell else { return UITableViewCell() }
            cell.configure(attentionMessage: presenter.attentionMessageForCell())
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractNationalitiesCell.reuseID, for: indexPath) as? CriminalExtractNationalitiesCell else { return UITableViewCell() }
            cell.configure(viewModel: presenter.viewModelForСell())
            return cell
        }
    }
}

extension CriminalExtractNationalitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case .zero:
            let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: Constants.headerHeight)))
            let label = UILabel(
                frame: CGRect(
                    origin: Constants.headerLabelOffset,
                    size: CGSize(width: tableView.frame.width - 24, height: 30)
                )
            )
            label.font = FontBook.detailsTitleFont
            label.text = R.Strings.criminal_certificate_request_address_picker_label_nationality.localized()
            headerView.addSubview(label)
            return headerView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case .zero:
            return Constants.headerHeight
        default: return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}
