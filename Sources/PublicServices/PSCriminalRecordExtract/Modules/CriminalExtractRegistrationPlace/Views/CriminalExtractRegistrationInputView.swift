import UIKit
import DiiaUIComponents
import DiiaCommonTypes

class CriminalExtractRegistrationInputView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var action: Callback?
    
    internal var currentValue: String? {
        return valueTextField.text
    }
    
    internal func setTitle(
        title: String,
        placeholder: String,
        action: Callback?
    ) {
        setValueText(
            string: placeholder,
            isPlaceholder: true
        )
        titleLabel.text = title
        self.action = action
    }
    
    internal func setValueText(
        string: String?,
        isPlaceholder: Bool = false
    ) {
        
        switch isPlaceholder {
        case true:
            valueTextField.placeholder = string
        case false:
            valueTextField.text = string
        }
    }
    
    @IBAction private func actionButton(_ sender: Any) {
        action?()
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
        setupLabels()
        setupAction()
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
    
    private func setupLabels() {
        valueTextField.borderStyle = .none
        valueTextField.isUserInteractionEnabled = false
        valueTextField.font = FontBook.bigText
        titleLabel.font = FontBook.smallTitle
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        action?()
    }
}
