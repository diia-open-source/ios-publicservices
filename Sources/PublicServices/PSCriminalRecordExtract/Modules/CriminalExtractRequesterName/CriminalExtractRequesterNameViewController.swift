import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalCertificateRequesterNameView: BaseView {
    func setContextMenuAvailable(isAvailable: Bool)
    func setLoadingState(_ state: LoadingState)
    func setActionButtonActive(_ bool: Bool)
    func updateTableView(row: Int)
}

final class CriminalExtractRequesterNameViewController: UIViewController {

    private enum Section: Int {
        case first
        case second
        case third
    }
    
	// MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var actionButton: LoadingStateButton!
    @IBOutlet private weak var actionButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorView: SeparatorBlurView!
    
	// MARK: - Properties
	var presenter: CriminalExtractRequesterNameAction!
    private var keyboardHandler: KeyboardHandler?
    private var token: NSKeyValueObservation?
    
	// MARK: - Init
	init() {
        super.init(nibName: CriminalExtractRequesterNameViewController.className, bundle: Bundle.module)
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
        setupKeyboardBehaviour()
        setupTableView()
        setupButtons()
    }
    
    private func setupKeyboardBehaviour() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
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
        tableView.register(CriminalExtractRequestNameMessageCell.nib,
                           forCellReuseIdentifier: CriminalExtractRequestNameMessageCell.reuseID)
        tableView.register(CriminalExtractRequestFullNameCell.nib,
                           forCellReuseIdentifier: CriminalExtractRequestFullNameCell.reuseID)
        tableView.register(CriminalCertRequesterNameAddCell.nib,
                           forCellReuseIdentifier: CriminalCertRequesterNameAddCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
    
    // MARK: - Actions
    @IBAction private func actionTapped() {
        presenter.actionTapped()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if actionButtonBottomConstraint.constant == .zero {
                self.actionButtonBottomConstraint.constant = keyboardSize.height
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if actionButtonBottomConstraint.constant != .zero {
            self.actionButtonBottomConstraint.constant = .zero
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

// MARK: - View logic
extension CriminalExtractRequesterNameViewController: CriminalCertificateRequesterNameView {
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
    
    func updateTableView(row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: Section.third.rawValue)], with: .automatic)
        updateSeparatorVisibility()
    }
    
    func setActionButtonActive(_ bool: Bool) {
        actionButton.setLoadingState(
            bool ? .solid : .disabled
        )
    }
}

// MARK: - Constants
extension CriminalExtractRequesterNameViewController {
    private enum Constants {
        static let screenCode = "requesterData"
        static let keyboardTopInset = 24.0
        static let numberOfSections = 3
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
        static let addCellText = [
            R.Strings.criminal_extract_request_name_last_name_previous.localized(),
            R.Strings.criminal_extract_request_name_first_name_previous.localized(),
            R.Strings.criminal_extract_request_name_second_name_previous.localized()
        ]
        static let addCellPlaceholderText = [
            R.Strings.criminal_extract_request_name_last_name.localized(),
            R.Strings.criminal_extract_request_name_first_name.localized(),
            R.Strings.criminal_extract_request_name_second_name.localized()
        ]
        static let addCellButtonText = [
            R.Strings.criminal_extract_request_name_last_name_add.localized(),
            R.Strings.criminal_extract_request_name_first_name_add.localized(),
            R.Strings.criminal_extract_request_name_second_name_add.localized()
        ]
    }
}

// MARK: - UITableViewDataSource
extension CriminalExtractRequesterNameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.first.rawValue:
            return 1
        case Section.second.rawValue:
            return 1
        case Section.third.rawValue:
            return 3
        default: return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case Section.first.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractRequestNameMessageCell.reuseID, for: indexPath) as? CriminalExtractRequestNameMessageCell else { return UITableViewCell() }
            if let message = presenter.parametrizedMessage {
                cell.configure(attentionMessage: message)
            }
            return cell
        
        case Section.second.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalExtractRequestFullNameCell.reuseID, for: indexPath) as? CriminalExtractRequestFullNameCell else { return UITableViewCell() }
            cell.configure(model: presenter.fullName)
            return cell
        
        case Section.third.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CriminalCertRequesterNameAddCell.reuseID, for: indexPath) as? CriminalCertRequesterNameAddCell else { return UITableViewCell() }
            cell.configure(
                addCellText: Constants.addCellText[indexPath.row],
                addCellPlaceholderText: Constants.addCellPlaceholderText[indexPath.row],
                addButtonText: Constants.addCellButtonText[indexPath.row],
                viewModel: presenter.viewModelForIndex(index: indexPath.row)
            ) { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        
        default: return UITableViewCell()
        }
    }
}

extension CriminalExtractRequesterNameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case .zero:
            let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 69)))
            let label = UILabel(
                frame: CGRect(
                    origin: CGPoint(x: 24, y: 24),
                    size: CGSize(width: tableView.frame.width - 24, height: 30)
                )
            )
            label.font = FontBook.detailsTitleFont
            label.text = R.Strings.criminal_certificate_request_set_name_page_title.localized()
            headerView.addSubview(label)
            return headerView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case .zero:
            return 69
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

extension CriminalExtractRequesterNameViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}
