import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol PublicServiceSearchView: BaseView {
    func update()
    func setupTable(items: [DSListItemViewModel])
}

final class PublicServiceSearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak private var topView: DSTopGroupView!
    @IBOutlet weak private var searchView: DSSearchInputView!
    @IBOutlet weak private var tableStackView: UIStackView!
    @IBOutlet weak private var emptyStateView: StubMessageViewV2!

    // MARK: - Properties
    var presenter: PublicServiceSearchAction!

    // MARK: - Init
    init() {
        super.init(nibName: PublicServiceSearchViewController.className, bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
        setupSearchViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.toggleSearch(active: true)
    }
    
    private func initialSetup() {
        view.addBackgroundImage(R.Image.light_background.image)
        topView.configure(navigationViewModel: .init(title: R.Strings.services_list_title.localized(),
                                                     backAction: {[weak self] in
            self?.closeModule(animated: true)
        }))
        
        emptyStateView.configure(with: .init(icon: "🤷‍♂️",
                                             title: R.Strings.public_services_search_empty.localized()))
    }
    
    private func setupSearchViews() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        view.isUserInteractionEnabled = true
        
        searchView.setup(placeholder: R.Strings.public_services_search_placeholder.localized(),
                         delegate: searchView,
                         isActive: true,
                         textChangeCallback: textChanged)
    }
    
    // MARK: - Actions
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func textChanged() {
        presenter.setSearch(search: searchView.searchText)
    }
}

// MARK: - View logic
extension PublicServiceSearchViewController: PublicServiceSearchView {
    func update() {
        let isAnyResult = presenter.numberOfItems() == 0 && (searchView.searchText?.count ?? 0 > 2)
        tableStackView.isHidden = isAnyResult
        emptyStateView.isHidden = !isAnyResult
    }
    
    func setupTable(items: [DSListItemViewModel]) {
        tableStackView.safelyRemoveArrangedSubviews()
        let view = DSWhiteColoredListView()
        view.configure(viewModel: .init(items: items))
        tableStackView.addArrangedSubview(view)
    }
}

extension PublicServiceSearchViewController {
    enum Constants {
        static let stubTopContentInset: CGFloat = 80
    }
}
