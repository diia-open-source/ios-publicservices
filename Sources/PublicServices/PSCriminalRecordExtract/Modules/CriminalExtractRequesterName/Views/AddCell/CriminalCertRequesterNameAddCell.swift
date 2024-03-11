import UIKit
import DiiaUIComponents

class CriminalCertRequesterNameAddCell: BaseTableNibCell, NibLoadable {

    typealias ViewModel = CriminalExtractRequestedNameViewModel
    
    @IBOutlet private weak var containterView: UIView!
    @IBOutlet private weak var addCellButtonContainer: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var addValueTextLabel: UILabel!
    
    @IBOutlet private weak var addImageView: UIImageView!
    private var viewModel: ViewModel?
    private var updateAction: (() -> Void)?
    
    internal func configure(
        addCellText: String,
        addCellPlaceholderText: String,
        addButtonText: String,
        viewModel: ViewModel,
        updateBlock: (() -> Void)?
    ) {
        self.viewModel = viewModel
        self.updateAction = updateBlock
        addValueTextLabel.text = addButtonText
        stackView.subviews.forEach({
            $0.removeFromSuperview()
        })
        
        setActiveAddView(viewModel.isEnabledAdding)
        
        if !viewModel.values.isEmpty {
            stackView.layoutMargins = Constants.stackViewInsets
        }
        
        viewModel.values.forEach({ value in
            let valueView = CriminalCertAddValueView()
            valueView.delegate = self
            valueView.configure(
                title: addCellText,
                placeholder: addCellPlaceholderText,
                text: value.value
            )
            valueView.setValidAppearance(value.isValid)
            stackView.addArrangedSubview(valueView)
        })
        containterView.layer.cornerRadius = 8.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containterView.layer.cornerRadius = 8.0
        addValueTextLabel.font = FontBook.usualFont
        let tap = UITapGestureRecognizer(target: self, action: #selector(addValueCell))
        addCellButtonContainer.addGestureRecognizer(tap)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.layoutMargins = .zero
        setActiveAddView(true)
    }
    
    private func setValidAppearance(bool: Bool) {
        
    }
    
    private func setActiveAddView(_ bool: Bool) {
        addValueTextLabel.textColor = bool ? .black : .gray
        addImageView.layer.opacity = bool ? 1.0 : 0.3
    }
    
    @objc private func addValueCell() {
        viewModel?.updateListAction?(.add)
    }
}

extension CriminalCertRequesterNameAddCell: CriminalCertAddValueViewDelegate {
    
    func didEditedData(valueView: CriminalCertAddValueView, oldValue: String, newValue: String) {
        setActiveAddView(!newValue.isEmpty)
        let literalRegex = #"^[А-ЩЬЮЯҐЄІЇа-щьюяґєії \x{2019} ʼ [:punct:]]{1,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", literalRegex)
        if !newValue.isEmpty {
            valueView.setValidAppearance(test.evaluate(with: newValue))
        } else { valueView.setValidAppearance(true) }
        updateAction?()
        viewModel?.updateListAction?(.editing(oldValue: oldValue, newValue: newValue))
    }
    
    func didRemovedValue(valueView: CriminalCertAddValueView, value: String) {
        valueView.removeFromSuperview()
        if stackView.subviews.count == 0 {
            stackView.layoutMargins = UIEdgeInsets.zero
        }
        setActiveAddView(true)
        viewModel?.updateListAction?(.remove(value: value))
        updateAction?()
    }
    
    func didFinisEditData(valueView: CriminalCertAddValueView, oldValue: String, newValue: String) {
        viewModel?.updateListAction?(.finishedEditing(oldValue: oldValue, newValue: newValue))
    }
}

extension CriminalCertRequesterNameAddCell {
    enum Constants {
        static let stackViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
