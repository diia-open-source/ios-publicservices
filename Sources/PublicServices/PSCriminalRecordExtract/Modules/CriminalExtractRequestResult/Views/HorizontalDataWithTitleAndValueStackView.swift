import UIKit
import DiiaUIComponents

class HorizontalDataWithTitleAndValueStackView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var additionalValueLabel: UILabel!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setUpUI() {
        self.titleLabel.font = FontBook.usualFont
        self.descriptionLabel.font = FontBook.usualFont
        self.additionalValueLabel.font = FontBook.usualFont
    }
    
    func setUp(title: String, value: String, additionalValues: String? = nil) {
        self.setUpUI()
        self.titleLabel.setTextWithCurrentAttributes(text: title, lineHeight: Constants.lineHeight)
        self.descriptionLabel.setTextWithCurrentAttributes(text: value, lineHeight: Constants.lineHeight)
        self.additionalValueLabel.text = ""
        if let additionalValues = additionalValues {
            self.additionalValueLabel.text = additionalValues
        }
    }
}

extension HorizontalDataWithTitleAndValueStackView {
    struct Constants {
        static let lineHeight: CGFloat = 16.0
    }
}
