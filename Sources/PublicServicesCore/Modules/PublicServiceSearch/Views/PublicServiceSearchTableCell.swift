import UIKit
import DiiaUIComponents

class PublicServiceSearchTableCell: BaseTableNibCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var additionalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func configure(service: PublicServiceSearchViewModel) {
        titleLabel.setTextWithCurrentAttributes(text: service.publicService.title)
        additionalLabel.setTextWithCurrentAttributes(text: service.categoryName)
    }
    
    private func setupUI() {
        titleLabel.font = FontBook.smallHeadingFont
        additionalLabel.font = FontBook.usualFont
    }
}
