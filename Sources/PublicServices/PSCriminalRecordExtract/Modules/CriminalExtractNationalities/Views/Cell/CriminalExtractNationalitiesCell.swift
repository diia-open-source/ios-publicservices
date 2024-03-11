import UIKit
import DiiaUIComponents

class CriminalExtractNationalitiesCell: BaseTableNibCell, NibLoadable {
    
    typealias ViewModel = CriminalExtractNationalitiesViewModel
    
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var addImageView: UIImageView!
    @IBOutlet private weak var addLabel: UILabel!
    @IBOutlet private weak var addViewContainer: UIView!
    
    private var viewModel: ViewModel?
    
    private lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    internal func configure(
        viewModel: ViewModel
    ) {
        self.viewModel = viewModel
        
        stackView.safelyRemoveArrangedSubviews()
        viewModel.nationalities.enumerated().forEach({ element in
            let arrangedView = CriminalExtractNationalitiesInputView()
            arrangedView.configure(
                text: element.element,
                isFirst: element.offset == .zero
            )
            arrangedView.delegate = self
            stackView.addArrangedSubview(arrangedView)
        })
        
        setActiveAddView(viewModel.isExpandable)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupAddView()
        setupContainerStackView()
    }
    
    private func indexOfSubview(_ subview: CriminalExtractNationalitiesInputView) -> Int {
        stackView.subviews.firstIndex(of: subview) ?? .zero
    }
    
    private func setupAddView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addAction))
        addViewContainer.addGestureRecognizer(tap)
        addLabel.font = FontBook.usualFont
        addLabel.text = R.Strings.criminal_extract_nationalities_add_nationality.localized()
    }
    
    private func setupContainerStackView() {
        containerStackView.insertSubview(backgroundContainerView, at: .zero)
        backgroundContainerView.fillSuperview()
    }
    
    private func setActiveAddView(_ bool: Bool) {
        addLabel.textColor = bool ? .black : .gray
        addImageView.layer.opacity = bool ? 1.0 : 0.3
        addViewContainer.isUserInteractionEnabled = bool
    }
    
    @objc private func addAction() {
        viewModel?.action?(.add)
    }
}

extension CriminalExtractNationalitiesCell: CriminalExtractNationalitiesDelegate {
    func needToRemove(view: CriminalExtractNationalitiesInputView) {
        viewModel?.action?(.remove(index: indexOfSubview(view)))
    }
    
    func needToChangeText(view: CriminalExtractNationalitiesInputView) {
        viewModel?.action?(.edit(index: indexOfSubview(view)))
    }
}
