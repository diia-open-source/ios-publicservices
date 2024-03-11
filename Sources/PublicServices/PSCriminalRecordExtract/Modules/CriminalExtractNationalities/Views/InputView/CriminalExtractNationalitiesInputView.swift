import UIKit

protocol CriminalExtractNationalitiesDelegate: AnyObject {
    func needToRemove(view: CriminalExtractNationalitiesInputView)
    func needToChangeText(view: CriminalExtractNationalitiesInputView)
}

class CriminalExtractNationalitiesInputView: UIView {
    
    internal weak var delegate: CriminalExtractNationalitiesDelegate?
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: CriminalExtractBirthPlaceInputView!
    @IBOutlet private weak var imageContainerView: UIView!
    
    internal func setText(_ text: String?) {
        containerView.setText(text)
    }
    
    internal func configure(
        text: String?,
        isFirst: Bool
    ) {
        if text != nil, !isFirst {
            imageContainerView.isHidden = false
        } else {
            imageContainerView.isHidden = true
        }
        
        containerView.setText(text)
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
        setupViews()
        setupActions()
        containerView.setValidAppearance(true)
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
    
    private func setupViews() {
        containerView.configure(
            title: Constants.title,
            placeholder: Constants.placeholder,
            isEditable: false
        )
    }
    
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerViewAction))
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(imViewAction))
        containerView.addGestureRecognizer(tap)
        imageContainerView.addGestureRecognizer(tapTwo)
    }
    
    @objc private func containerViewAction() {
        delegate?.needToChangeText(view: self)
    }
    
    @objc private func imViewAction() {
        delegate?.needToRemove(view: self)
    }
}

extension CriminalExtractNationalitiesInputView {
    private enum Constants {
        static let title = R.Strings.criminal_extract_birth_place_country_title.localized()
        static let placeholder = R.Strings.criminal_extract_birth_place_country_placeholder_list.localized()
    }
}
