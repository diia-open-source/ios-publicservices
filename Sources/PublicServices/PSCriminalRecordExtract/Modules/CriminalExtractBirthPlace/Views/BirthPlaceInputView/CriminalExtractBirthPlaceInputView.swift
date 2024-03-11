import UIKit
import DiiaUIComponents

protocol CriminalBirthPlaceInputViewDelegate: AnyObject {
    func textDidFinishEditing(
        criminalView: CriminalExtractBirthPlaceInputView,
        newText: String
    )
    
    func textDidEdit(
        criminalView: CriminalExtractBirthPlaceInputView,
        newText: String
    )
}

extension CriminalBirthPlaceInputViewDelegate {
    func textDidEdit(
        criminalView: CriminalExtractBirthPlaceInputView,
        newText: String
    ) {}
}

class CriminalExtractBirthPlaceInputView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var arrowContainerView: UIView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    
    internal weak var delegate: CriminalBirthPlaceInputViewDelegate?
    private let errorColor = UIColor("#CA2F28")
    
    internal func setText(_ text: String?) {
        textField.text = text
    }
    
    internal func configure(
        title: String,
        placeholder: String,
        text: String? = nil,
        description: String? = nil,
        isEditable: Bool = true
    ) {
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.text = text
        descriptionLabel.text = description
        textField.isUserInteractionEnabled = isEditable
        arrowContainerView.isHidden = isEditable
    }
    
    internal func setValidAppearance(_ bool: Bool) {
        descriptionLabel.isHidden = !bool
        errorLabel.isHidden = bool
        separatorView.backgroundColor = bool ? .black.withAlphaComponent(0.3) : errorColor
        textField.textColor = bool ? .black : errorColor
        invalidateIntrinsicContentSize()
    }
    
    internal func setActiveState(_ bool: Bool, isActiveTitle: Bool = false) {
        isUserInteractionEnabled = bool
        arrowImageView.alpha = bool ? 1.0 : 0.3
        textField.textColor = bool ? .black : .black.withAlphaComponent(0.3)
        if isActiveTitle { titleLabel.textColor = .black } else {
            titleLabel.textColor = bool ? .black : .black.withAlphaComponent(0.3)
        }
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
        setupImageView()
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
        textField.smartInsertDeleteType = .no
        textField.smartQuotesType = .no
        textField.delegate = self
        titleLabel.font = FontBook.smallTitle
        descriptionLabel.font = FontBook.smallTitle
        errorLabel.textColor = errorColor
        errorLabel.font = FontBook.smallTitle
        descriptionLabel.textColor = .black.withAlphaComponent(0.3)
    }

    private func setupImageView() {
        arrowImageView.image = R.Image.right_arrow.image
        arrowImageView.alpha = 1.0
    }
}
extension CriminalExtractBirthPlaceInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
            let rangeOfTextToReplace = Range(range, in: text) else {
                return false
        }
        let substringToReplace = text[rangeOfTextToReplace]
        let count = text.count - substringToReplace.count + string.count
        if count <= 30 {
            delegate?.textDidEdit(criminalView: self, newText: (text as NSString).replacingCharacters(in: range, with: string))
        }
        return  count <= 30
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? .empty
        delegate?.textDidFinishEditing(
            criminalView: self,
            newText: text
        )
    }
}
