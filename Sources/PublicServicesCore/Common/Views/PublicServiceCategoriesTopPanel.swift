import UIKit
import DiiaUIComponents

protocol PublicServiceCategoriesTopPanelDelegate: AnyObject {
    func didSelectSearch()
}

class PublicServiceCategoriesTopPanel: BaseCollectionNibView, NibLoadable {
    
    class func height(isTabSwitcherAvailable: Bool) -> CGFloat {
        return (isTabSwitcherAvailable ? Constants.height : Constants.heightWithoutTabs)
    }

    // MARK: - Outlets
    @IBOutlet private weak var searchLabel: UILabel!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var tabSwitcher: RoundedTabSwitcherView!
    
    // MARK: - Properties
    weak var delegate: PublicServiceCategoriesTopPanelDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchLabel.font = FontBook.usualFont
        searchLabel.text = R.Strings.public_services_search.localized()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchClick))
        searchView.addGestureRecognizer(tap)
        searchView.isUserInteractionEnabled = true
    }
    
    // MARK: - Public Methods
    func configure(delegate: PublicServiceCategoriesTopPanelDelegate? = nil, tabVM: TabSwitcherViewModel) {
        self.delegate = delegate
        
        // Configure tab switcher
        let isTabSwitcherAvailable = tabVM.items.count > 1
        tabSwitcher.isHidden = !isTabSwitcherAvailable
        isTabSwitcherAvailable ? tabSwitcher.configure(viewModel: tabVM) : ()
    }
    
    // MARK: - Actions
    @objc private func searchClick() {
        delegate?.didSelectSearch()
    }
}

private extension PublicServiceCategoriesTopPanel {
    enum Constants {
        static let height: CGFloat = 134
        static let heightWithoutTabs: CGFloat = 72
    }
}
