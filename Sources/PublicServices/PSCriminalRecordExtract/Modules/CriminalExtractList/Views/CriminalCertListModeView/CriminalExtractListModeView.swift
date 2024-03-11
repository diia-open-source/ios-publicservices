import UIKit
import DiiaUIComponents

protocol CriminalCertListModeViewDelegate: AnyObject {
    func didSelectCategory(
        view: CriminalExtractListModeView,
        category: CertificateStatus
    )
}

class CriminalExtractListModeView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftSeparator: UIView!
    @IBOutlet private weak var rightSeparator: UIView!
    
    internal weak var delegate: CriminalCertListModeViewDelegate?
    
    internal var currentType: CertificateStatus = .done {
        didSet {
            switch currentType {
            case .applicationProcessing:
                leftSeparator.isHidden = true
                rightSeparator.isHidden = false
            case .done:
                leftSeparator.isHidden = false
                rightSeparator.isHidden = true
            }
        }
    }
    
    @IBAction private func leftBtnAction(_ sender: Any) {
        currentType = .done
        delegate?.didSelectCategory(
            view: self,
            category: .done
        )
    }
    
    @IBAction private func rightBtnAction(_ sender: Any) {
        currentType = .applicationProcessing
        delegate?.didSelectCategory(
            view: self,
            category: .applicationProcessing
        )
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
        setupButtons()
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
    
    private func setupButtons() {
        leftButton.setTitleColor(.black, for: .normal)
        rightButton.setTitleColor(.black, for: .normal)

        leftButton.setAttributedTitle(
            NSAttributedString(
                string: R.Strings.criminal_cert_list_done.localized(),
                attributes: [
                    .font: FontBook.smallHeadingFont,
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        rightButton.setAttributedTitle(
            NSAttributedString(
                string: R.Strings.criminal_cert_list_ordered.localized(),
                attributes: [
                    .font: FontBook.smallHeadingFont,
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
    }
}
