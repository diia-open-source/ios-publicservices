import UIKit
import DiiaUIComponents

class ServiceActiveTableCell: BaseTableNibCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var countView: UIView!
    
    private var viewModel: PublicServiceShortViewModel?
    private var observations: [NSKeyValueObservation] = []

    // MARK: - Life
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        observations = []
        viewModel = nil
    }

    // MARK: - Setup
    func setupUI(font: UIFont = FontBook.bigText,
                 textColor: UIColor = .black,
                 countLabelFont: UIFont = FontBook.usualFont,
                 backgroundColor: UIColor = .clear) {
        titleLabel?.font = font
        titleLabel?.textColor = textColor
        countLabel.font = countLabelFont
        self.backgroundColor = backgroundColor
    }
    
    private func setup() {
        countView.layer.cornerRadius = countView.frame.size.height/2.0
    }
    
    // MARK: - Configuration
    func configure(viewModel: PublicServiceShortViewModel) {
        self.viewModel = viewModel
        
        if viewModel.inBetaMode {
            let attributedTitle = NSMutableAttributedString(string: viewModel.title)
            attributedTitle.append(NSAttributedString(string: " "))
            titleLabel.attributedText = attributedTitle.finalizeWithImage(imageName: "beta")
        } else {
            titleLabel.text = viewModel.title
        }
        
        observations = [
            viewModel.observe(\.counter, onChange: { [weak self] (counter) in
                self?.countLabel.text = "\(counter)"
                self?.countView.isHidden = counter == 0
            })
        ]
    }
}
