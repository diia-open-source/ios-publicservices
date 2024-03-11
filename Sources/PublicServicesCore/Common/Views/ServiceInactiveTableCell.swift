import UIKit
import DiiaUIComponents

class ServiceInactiveTableCell: BaseTableNibCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = FontBook.bigText
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
