import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol PublicServiceCategoriesListView: BaseView {
    func setState(state: LoadingState)
    func reloadSelectedTabItems()
}

final class PublicServiceCategoriesListViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    @IBOutlet private weak var topView: TopNavigationBigView!
    @IBOutlet private weak var contentLoadingView: ContentLoadingView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    // MARK: - Properties
    var presenter: PublicServiceCategoriesListAction!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.Strings.services_list_title.localized()
        emptyLabel.font = FontBook.detailsTitleFont
        emptyLabel.text = R.Strings.services_unavailable.localized()
        setupCollectionView()
        topView.configure(viewModel: .init(title: R.Strings.services_list_title.localized()))
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.updateServices()
    }

    // MARK: - Configuration
    private func setupCollectionView() {
        collectionView.register(PublicServiceCategoriesTopPanel.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PublicServiceCategoriesTopPanel.reuseID)
        collectionView.register(PublicServiceShortCollectionCell.nib, forCellWithReuseIdentifier: PublicServiceShortCollectionCell.reuseID)
        
        collectionView.contentInset = .zero
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - View logic
extension PublicServiceCategoriesListViewController: PublicServiceCategoriesListView {
    func setState(state: LoadingState) {
        contentLoadingView.setLoadingState(state)
        collectionView.isHidden = state == .loading && presenter.numberOfItems() == 0
        emptyLabel.isHidden = state == .loading || !collectionView.isHidden
        if state == .ready { update() }
    }

    func reloadSelectedTabItems() {
        update()
    }

    private func update() {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.flashScrollIndicators()
    }

    func showProgress() {
        contentLoadingView.setLoadingState(.loading)
    }

    func hideProgress() {
        contentLoadingView.setLoadingState(.ready)
    }
}

// MARK: - UICollectionViewDataSource
extension PublicServiceCategoriesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = presenter.itemAt(index: indexPath.item) else { return UICollectionViewCell() }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicServiceShortCollectionCell.reuseID, for: indexPath) as? PublicServiceShortCollectionCell {
            cell.configure(with: vm.name, iconName: vm.imageName, isActive: vm.status == .active)
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PublicServiceCategoriesTopPanel.reuseID, for: indexPath) as? PublicServiceCategoriesTopPanel else { return UICollectionReusableView() }

        let tabVM = presenter.getTabsViewModel()
        headerView.configure(delegate: self, tabVM: tabVM)
        return headerView
    }
}

// MARK: - UICollectionViewDelegate
extension PublicServiceCategoriesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.itemSelected(index: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PublicServiceCategoriesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (UIScreen.main.bounds.width - Constants.commonHorizontalSpacing) / 2,
            height: Constants.shortCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: UIScreen.main.bounds.width,
                     height: PublicServiceCategoriesTopPanel.height(isTabSwitcherAvailable: presenter.getTabsViewModel().items.count > 1))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interitemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.collectionViewInsets
    }
}

// MARK: - PublicServiceCategoriesTopPanelDelegate
extension PublicServiceCategoriesListViewController: PublicServiceCategoriesTopPanelDelegate {
    func didSelectSearch() {
        presenter.searchClick()
    }
}

private extension PublicServiceCategoriesListViewController {
    enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
        static let shortCellHeight: CGFloat = 112
        static let commonHorizontalSpacing: CGFloat = 56
        static let collectionViewInsets: UIEdgeInsets = .init(top: 0, left: 24, bottom: 32, right: 24)
        static let interitemSpacing: CGFloat = 8
    }
}
