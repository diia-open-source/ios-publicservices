import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractBirthPlaceView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(_ state: LoadingState)
    func updateSection(index: Int)
    func setActionButtonActive(_ bool: Bool) 
}

final class CriminalExtractBirthPlaceViewController: UIViewController {

	// MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var separatorView: SeparatorBlurView!
    
    // MARK: - Properties
	var presenter: CriminalExtractBirthPlaceAction!
    private var keyboardHandler: KeyboardHandler?
    private var token: NSKeyValueObservation?
    
	// MARK: - Init
	init() {
        super.init(nibName: CriminalExtractBirthPlaceViewController.className, bundle: Bundle.module)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSeparatorVisibility()
    }
    
    private func initialSetup() {
        setupTopView()
        setupKeyboard()
        setupTableView()
        setupButtons()
    }
    
    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
        keyboardHandler = KeyboardHandler(type: .constraint(constraint: actionButtonBottomConstraint, withoutInset: AppConstants.Layout.buttonBottomOffset, keyboardInset: Constants.keyboardTopInset, superview: self.view))
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
        tableView.estimatedRowHeight = Constants.estimatedCellHeight
        tableView.separatorStyle = .none
        tableView.register(
            CriminalExtractBirthPlaceCountryCell.nib,
            forCellReuseIdentifier: CriminalExtractBirthPlaceCountryCell.reuseID
        )
        
        tableView.register(
            CriminalExtractBirthPlaceCityCell.nib,
            forCellReuseIdentifier: CriminalExtractBirthPlaceCityCell.reuseID
        )
        
        token = tableView.observe(\.contentSize, options: [.old, .new]) { [weak self] _, _ in
            self?.updateSeparatorVisibility()
        }
    }
    
    private func setupButtons() {
        actionButton.setLoadingState(.solid, withTitle: R.Strings.general_next.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.contentEdgeInsets = Constants.buttonInsets
        actionButtonBottomConstraint.constant = AppConstants.Layout.buttonBottomOffset
    }
    
    private func updateSeparatorVisibility() {
        let contentHeight = Int(tableView.contentSize.height)
        let fullOffset = Int(tableView.contentOffset.y + tableView.frame.height)
        separatorView.isHidden = contentHeight <= fullOffset
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction private func actionTapped() {
        presenter.actionTapped()
    }
}

// MARK: - View logic
extension CriminalExtractBirthPlaceViewController: CriminalExtractBirthPlaceView {
    func setContextMenuAvailable(isAvailable: Bool) {
        topView.setupOnContext(callback: isAvailable
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
    }
    
    func setLoadingState(_ state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        contentView.isHidden = state == .loading
        if state == .ready {
            tableView.reloadData()
            updateSeparatorVisibility()
        }
    }
    
    func updateSection(index: Int) {
        tableView.reloadRows(
            at: [IndexPath(row: .zero, section: index)],
            with: .automatic
        )
    }
    
    func setActionButtonActive(_ bool: Bool) {
        actionButton.setLoadingState(
            bool ? .solid : .disabled
        )
    }
}

// MARK: - Constants
extension CriminalExtractBirthPlaceViewController {
    private enum Constants {
        static let screenCode = "birthPlace"
        static let keyboardTopInset = 24.0
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
        static let numberOfItems = 1
        static let estimatedCellHeight = 100.0
        static let headerHeight = 69.0
        static let headerLabelOffset = CGPoint(x: 24, y: 24)
        static let headerLabelHeight = 30.0
    }
}

extension CriminalExtractBirthPlaceViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}

extension CriminalExtractBirthPlaceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if presenter.isCountryProvided || indexPath.section != .zero {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractBirthPlaceCityCell.reuseID, for: indexPath) as? CriminalExtractBirthPlaceCityCell else { return UITableViewCell() }
            cell.configure(viewModel: presenter.viewModelForSection(
                    section: indexPath.section
            ))
            cell.onChangeSizeAction = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractBirthPlaceCountryCell.reuseID, for: indexPath) as? CriminalExtractBirthPlaceCountryCell else { return UITableViewCell() }
            cell.configure(viewModel: presenter.viewModelForSection(section: indexPath.section))
            cell.onChangeSizeAction = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        }
    }
}

extension CriminalExtractBirthPlaceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case .zero:
            let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: Constants.headerHeight)))
            let label = UILabel(
                frame: CGRect(
                    origin: Constants.headerLabelOffset,
                    size: CGSize(width: tableView.frame.width - Constants.headerLabelOffset.x, height: Constants.headerLabelHeight)
                )
            )
            label.font = FontBook.detailsTitleFont
            label.text = R.Strings.criminal_extract_birth_place_title.localized()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSeparatorVisibility()
    }
}
