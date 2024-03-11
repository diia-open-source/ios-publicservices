import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol CriminalExtractListView: BaseView {
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol)
    func setLoadingState(_ state: LoadingState)
    func configureStubMessage(message: AttentionMessage?)
    func tableViewShouldReload()
    func updateBackgroundColor()
}

final class CriminalExtractListViewController: UIViewController {

	// MARK: - Outlets
    @IBOutlet weak private var topView: TopNavigationView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var listModeView: CriminalExtractListModeView!
    @IBOutlet private weak var actionButton: LoadingStateButton!
    
    @IBOutlet private weak var statusStackView: UIStackView!
    
    @IBOutlet private weak var separatorView: SeparatorBlurView!
    @IBOutlet private weak var statusIconLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    // MARK: - Properties
	var presenter: CriminalExtractListAction!
    private var token: NSKeyValueObservation?
    
	// MARK: - Init
	init() {
        super.init(nibName: CriminalExtractListViewController.className, bundle: Bundle.module)
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
        setupButtons()
        setupTableView()
        setupStartServiceView()
        setupListModeView()
    }
    
    private func setupListModeView() {
        listModeView.delegate = self
        listModeView.currentType = presenter.currentType
    }
    
    private func setupTopView() {
        topView.setupTitle(title: R.Strings.criminal_extract_title.localized())
        topView.setupOnClose(callback: { [weak self] in
            self?.closeModule(animated: true)
        })
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CriminalExtractListCell.nib, forCellReuseIdentifier: CriminalExtractListCell.reuseID)
        token = tableView.observe(\.contentSize, options: [.old, .new]) { [weak self] _, _ in
            self?.updateSeparatorVisibility()
        }
    }
    
    private func setupStartServiceView() {
        statusStackView.isHidden = true
        statusLabel.font = FontBook.bigText
    }
    
    private func setupButtons() {
        actionButton.setLoadingState(.solid, withTitle: R.Strings.registration_extract_action.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.contentEdgeInsets = Constants.buttonInsets
    }
    
    private func updateSeparatorVisibility() {
        let contentHeight = Int(tableView.contentSize.height)
        let fullOffset = Int(tableView.contentOffset.y + tableView.frame.height)
        separatorView.isHidden = contentHeight <= fullOffset
    }
    
    // MARK: - Actions
    @IBAction private func actionTapped() {
        presenter.actionTapped(animated: true)
    }
}

// MARK: - View logic
extension CriminalExtractListViewController: CriminalExtractListView {
    func setupHeader(contextMenuProvider: ContextMenuProviderProtocol) {
        topView.setupTitle(title: contextMenuProvider.title ?? "")
        topView.setupOnContext(callback: contextMenuProvider.hasContextMenu()
                               ? { [weak self] in self?.presenter.openContextMenu() }
                               : nil)
    }
    
    func setLoadingState(_ state: LoadingState) {
        topView.setupLoading(isActive: state == .loading)
        contentView.isHidden = state == .loading
        listModeView.isHidden = state == .loading
    }
    
    func tableViewShouldReload() {
        tableView.reloadData()
        updateSeparatorVisibility()
    }
    
    func configureStubMessage(message: AttentionMessage?) {
        guard let message = message else {
            statusStackView.isHidden = true
            return
        }
        statusStackView.isHidden = false
        statusIconLabel.text = message.icon
        statusLabel.text = message.text
    }
    
    func updateBackgroundColor() {
        view.backgroundColor = UIColor(AppConstants.Colors.emptyDocumentsBackground)
    }
}

// MARK: - Constants
extension CriminalExtractListViewController {
    private enum Constants {
        static let screenCode = "home"
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
    }
}

extension CriminalExtractListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CriminalExtractListCell.reuseID,
            for: indexPath) as? CriminalExtractListCell else {
            return UITableViewCell()
        }
        cell.configure(
            with: presenter.getViewModelFor(
                index: indexPath.row
            )
        )
        return cell
    }
}

extension CriminalExtractListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSeparatorVisibility()
    }
}

extension CriminalExtractListViewController: CriminalCertListModeViewDelegate {
    func didSelectCategory(
        view: CriminalExtractListModeView,
        category: CertificateStatus
    ) {
        presenter.loadCellsFor(category: category)
    }
}

extension CriminalExtractListViewController: RatingFormHolder {
    func screenCode() -> String {
        return Constants.screenCode
    }
}
