import UIKit
import DiiaUIComponents

class CriminalExtractListCell: BaseTableNibCell, NibLoadable {

    typealias ViewModel = CriminalCertificateRequestMainViewModel
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var labelStatusView: LabelStatusView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var extractTypeLabel: UILabel!
    @IBOutlet private weak var shadowView: ShadowView!
    
    private var viewModel: ViewModel?
    
    internal func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.reason
        dateLabel.text = viewModel.date
        extractTypeLabel.text = viewModel.type
        if CertificateStatus(rawValue: viewModel.status) == .done {
            labelStatusView.configure(
                text: R.Strings.registration_extract_done.localized(),
                backgroundColorHex: Constants.doneBackgroundHex,
                textColorHex: Constants.doneTextHex
            )
        } else if CertificateStatus(rawValue: viewModel.status) == .applicationProcessing {
            labelStatusView.configure(
                text: R.Strings.registration_extract_processing.localized(),
                backgroundColorHex: Constants.processingBackgroungHex,
                textColorHex: Constants.processingTextHex
            )
        } else {
            labelStatusView.isHidden = true
        }
        
        containerView.layer.cornerRadius = Constants.cornerRadius
    }
    
    @IBAction private func buttonAction(_ sender: Any) {
        viewModel?.action.callback()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
        setupButton()
        setupContainer()
        selectionStyle = .none
        shadowView.setupShadow(
            color: UIColor(hex: 0x16222E29),
            alpha: 0.16,
            x: 0,
            y: 25,
            blur: 16,
            spread: -20
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layoutIfNeeded()
    }
    
    private func setupContainer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerTapAction))
        containerView.addGestureRecognizer(tap)
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.bigText
        dateLabel.font = FontBook.usualFont
        extractTypeLabel.font = FontBook.usualFont
    }
    
    private func setupButton() {
        actionButton.setAttributedTitle(
            NSAttributedString(
                string: R.Strings.general_details.localized(),
                attributes: [
                    .font: FontBook.usualFont,
                    .foregroundColor: UIColor.white
                ]
            ),
            for: .normal)
        actionButton.backgroundColor = .black
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
        actionButton.contentEdgeInsets = Constants.buttonInsets
    }
    
    @objc private func containerTapAction() {
        viewModel?.action.callback()
    }
}

extension CriminalExtractListCell {
    enum Constants {
        static let doneText = ""
        static let processingText = ""
        static let processingTextHex = "#000000"
        static let processingBackgroungHex = "#FFD600"
        static let doneTextHex = "#FFFFFF"
        static let doneBackgroundHex = "#19BE6F"
        static let buttonInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        static let cornerRadius = 8.0
    }
}
