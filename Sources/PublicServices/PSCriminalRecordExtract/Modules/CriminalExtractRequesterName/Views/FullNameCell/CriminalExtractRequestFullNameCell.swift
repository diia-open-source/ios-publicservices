import UIKit
import DiiaUIComponents
import DiiaCommonTypes

class CriminalExtractRequestFullNameCell: BaseTableNibCell, NibLoadable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    internal func configure(model: LabelValueModel) {
        titleLabel.text = model.label
        valueLabel.text = model.value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 8.0
        setupLabels()
    }
    
    private func setupLabels() {
        titleLabel.font = FontBook.usualFont
        valueLabel.font = FontBook.smallHeadingFont
    }
}
