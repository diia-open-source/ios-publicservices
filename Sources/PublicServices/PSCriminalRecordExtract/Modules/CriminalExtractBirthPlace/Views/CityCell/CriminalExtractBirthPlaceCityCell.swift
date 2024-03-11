import UIKit
import DiiaUIComponents

class CriminalExtractBirthPlaceCityCell: BaseTableNibCell, NibLoadable {

    typealias ViewModel = CriminalExtractBirthPlaceViewModel
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var cellView: CriminalExtractBirthPlaceInputView!
    @IBOutlet private weak var viewHeightConstaint: NSLayoutConstraint!
    private var viewModel: ViewModel?
    
    internal var onChangeSizeAction: (() -> Void)?
    
    internal func configure(viewModel: ViewModel) {
        self.viewModel = viewModel

        cellView.configure(
            title: viewModel.title,
            placeholder: viewModel.placeholder,
            text: viewModel.text,
            description: viewModel.description
        )
        setViewAppearance(isValid: viewModel.isValidAppearance)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 8.0
        cellView.delegate = self
    }
    
    private func setViewAppearance(isValid: Bool) {
        cellView.setValidAppearance(isValid)
        onChangeSizeAction?()
        guard let viewModel = viewModel else { return }
        if viewModel.description != nil {
            viewHeightConstaint.constant = isValid ? Constants.validFullHeight : Constants.invalidHeight
        } else {
            viewHeightConstaint.constant = isValid ? Constants.validHeight : Constants.invalidHeight
        }
        layoutIfNeeded()
    }
}

extension CriminalExtractBirthPlaceCityCell {
    private enum Constants {
        static let validHeight = 46.0
        static let validFullHeight = 65.0
        static let invalidHeight = 65.0
    }
}

extension CriminalExtractBirthPlaceCityCell: CriminalBirthPlaceInputViewDelegate {
    func textDidEdit(
        criminalView: CriminalExtractBirthPlaceInputView,
        newText: String
    ) {
        let literalRegex = #"^[А-ЩЬЮЯҐЄІЇа-щьюяґєії \x{2019} ʼ [:punct:]]{1,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", literalRegex)
        
        if !newText.isEmpty {
            setViewAppearance(isValid: test.evaluate(with: newText))
        } else { setViewAppearance(isValid: true) }
        onChangeSizeAction?()
        viewModel?.updateTextAction?(.editing(newText))
    }
    
    func textDidFinishEditing(
        criminalView: CriminalExtractBirthPlaceInputView,
        newText: String
    ) {
        viewModel?.updateTextAction?(.finishedEdit(newText))
    }
}
