import UIKit
import DiiaUIComponents

protocol CriminalCertAddValueViewDelegate: AnyObject {
    func didRemovedValue(
        valueView: CriminalCertAddValueView,
        value: String
    )
    
    func didEditedData(
        valueView: CriminalCertAddValueView,
        oldValue: String,
        newValue: String
    )
    
    func didFinisEditData(
        valueView: CriminalCertAddValueView,
        oldValue: String,
        newValue: String
    )
}

class CriminalCertAddValueView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var separatorBottomContraint: NSLayoutConstraint!
    @IBOutlet private weak var errorLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorView: UIView!
    
    internal weak var delegate: CriminalCertAddValueViewDelegate?
    private var oldValue: String = .empty
    private let errorColor =  UIColor(AppConstants.Colors.persianRed)
    
    @IBAction private func editingDidChange(_ sender: Any) {
        delegate?.didEditedData(valueView: self, oldValue: oldValue, newValue: textField.text ?? "")
        oldValue = textField.text ?? .empty
    }
    
    @IBAction private func onButtonAction(_ sender: Any) {
        delegate?.didRemovedValue(
            valueView: self,
            value: textField.text ?? .empty
        )
    }
    
    internal func configure(
        title: String,
        placeholder: String,
        text: String? = nil
    ) {
        placeholderLabel.text = title
        textField.placeholder = placeholder
        textField.text = text
        oldValue = text ?? .empty
    }
    
    internal func setValidAppearance(_ bool: Bool) {
        errorLabel.textColor = errorColor
        separatorView.backgroundColor = bool ? .black.withAlphaComponent(0.3) : errorColor
        textField.textColor = bool ? .black : errorColor
        separatorBottomContraint.constant = bool ? Constants.validSeparatorBottomConstr : Constants.invalidSeparatorBottomConstr
        errorLabelHeightConstraint.constant = bool ? Constants.validLabelHeight : Constants.invalidLabelHeight
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        fromNib(bundle: Bundle.module)
        setupContentView()
        setupTextField()
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.frame
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupTextField() {
        textField.autocapitalizationType = .words
        textField.borderStyle = .none
        textField.font = FontBook.bigText
        textField.delegate = self
        textField.smartInsertDeleteType = .no
        textField.smartQuotesType = .no
        placeholderLabel.font = FontBook.smallTitle
        errorLabel.font = FontBook.smallTitle
    }
}

extension CriminalCertAddValueView {
    enum Constants {
        static let validLabelHeight: CGFloat = .zero
        static let invalidLabelHeight: CGFloat = 12.0
        static let validSeparatorBottomConstr: CGFloat = .zero
        static let invalidSeparatorBottomConstr: CGFloat = 8.0
    }
}

extension CriminalCertAddValueView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 70
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didFinisEditData(valueView: self, oldValue: oldValue, newValue: textField.text ?? .empty)
        oldValue = textField.text ?? .empty
    }
}
