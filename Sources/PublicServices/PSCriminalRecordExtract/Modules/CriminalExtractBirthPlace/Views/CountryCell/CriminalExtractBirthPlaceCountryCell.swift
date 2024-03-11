import UIKit
import DiiaUIComponents

class CriminalExtractBirthPlaceCountryCell: BaseTableNibCell, NibLoadable {

    typealias ViewModel = CriminalExtractBirthPlaceViewModel
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var mainCountryView: CriminalExtractBirthPlaceInputView!
    @IBOutlet private weak var extraCountryView: CriminalExtractBirthPlaceInputView!
    @IBOutlet private weak var checkboxLabel: UILabel!
    @IBOutlet private weak var checkBoxView: UIImageView!
    @IBOutlet weak private var extraCountryViewHeight: NSLayoutConstraint!
    
    internal var onChangeSizeAction: (() -> Void)?
    private var viewModel: ViewModel?
    
    private lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    internal func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        extraCountryView.isHidden = !viewModel.state
        extraCountryView.setValidAppearance(viewModel.isValidAppearance)
        
        if !viewModel.isEditable {
            mainCountryView.setActiveState(false, isActiveTitle: true)
        } else { mainCountryView.setActiveState(!viewModel.state) }
        
        switch viewModel.state {
        case true:
            checkBoxView.image = R.Image.checkbox_enabled.image
            mainCountryView.setText(nil)
            extraCountryView.setText(viewModel.text)
        case false:
            checkBoxView.image = R.Image.checkbox_disabled.image
            mainCountryView.setText(viewModel.text)
            extraCountryView.setText(nil)
        }
        
        setExtraCoutryViewAppearanceState(isValid: viewModel.isValidAppearance)
        setSubviewsEnableState(viewModel.isEditable)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAction()
        configureViews()
        extraCountryView.delegate = self
    }
    
    private func configureViews() {
        mainCountryView.configure(
            title: Constants.title,
            placeholder: Constants.mainPlaceholder,
            isEditable: false
        )
        mainCountryView.setValidAppearance(true)
        extraCountryView.configure(
            title: Constants.title,
            placeholder: Constants.extraPlaceholder
        )
        extraCountryView.setValidAppearance(true)
        checkboxLabel.text = Constants.checkBoxTitle
        selectionStyle = .none
        stackView.layer.cornerRadius = Constants.cornerRadius
        checkboxLabel.font = FontBook.usualFont
        stackView.insertSubview(backgroundContainerView, at: .zero)
        backgroundContainerView.fillSuperview()
    }
    
    private func configureAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkBoxTap))
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(checkBoxTap))
        let tapThree = UITapGestureRecognizer(target: self, action: #selector(mainViewAction))
        checkBoxView.isUserInteractionEnabled = true
        checkboxLabel.isUserInteractionEnabled = true
        checkBoxView.addGestureRecognizer(tap)
        checkboxLabel.addGestureRecognizer(tapTwo)
        mainCountryView.addGestureRecognizer(tapThree)
    }
    
    private func setExtraCoutryViewAppearanceState(isValid: Bool) {
        extraCountryView.setValidAppearance(isValid)
        extraCountryViewHeight.constant = isValid ? Constants.validHeight : Constants.invalidHeight
        layoutIfNeeded()
    }
    
    private func setSubviewsEnableState(_ bool: Bool) {
        mainCountryView.isUserInteractionEnabled = bool
        checkBoxView.isUserInteractionEnabled = bool
        checkboxLabel.isUserInteractionEnabled = bool
        checkboxLabel.textColor = bool ? .black : .black.withAlphaComponent(CGFloat(Constants.deselectedAlpha))
        checkBoxView.layer.opacity = bool ? Constants.selectedAlpha : Constants.deselectedAlpha
    }
    
    @objc private func checkBoxTap() {
        guard let vm = viewModel else { return }
        vm.toggleAction?(!vm.state)
    }
    
    @objc private func mainViewAction() {
        guard let viewModel = viewModel else { return }
        viewModel.updateTextAction?(.finishedEdit(nil))
    }
}

extension CriminalExtractBirthPlaceCountryCell {
    private enum Constants {
        static let title = R.Strings.criminal_extract_birth_place_country_title.localized()
        static let checkBoxTitle =  R.Strings.criminal_extract_birth_place_checkBox.localized()
        static let mainPlaceholder = R.Strings.criminal_extract_birth_place_country_placeholder_list.localized()
        static let extraPlaceholder = R.Strings.criminal_extract_birth_place_country_placeholder_manual.localized()
        static let validHeight = 46.0
        static let invalidHeight = 65.0
        static let cornerRadius = 8.0
        static let selectedAlpha: Float = 1.0
        static let deselectedAlpha: Float = 0.3
    }
}

extension CriminalExtractBirthPlaceCountryCell: CriminalBirthPlaceInputViewDelegate {
    func textDidEdit(criminalView: CriminalExtractBirthPlaceInputView, newText: String) {
        let literalRegex = #"^[А-ЩЬЮЯҐЄІЇа-щьюяґєії \x{2019} ʼ [:punct:]]{1,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", literalRegex)
        
        if !newText.isEmpty {
            setExtraCoutryViewAppearanceState(isValid: test.evaluate(with: newText))
        } else { setExtraCoutryViewAppearanceState(isValid: true) }
        onChangeSizeAction?()
        viewModel?.updateTextAction?(.editing(newText))
    }
    
    func textDidFinishEditing(criminalView: CriminalExtractBirthPlaceInputView, newText: String) {
        viewModel?.updateTextAction?(.finishedEdit(newText))
    }
}
