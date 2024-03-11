import UIKit
import DiiaUIComponents

class CriminalExtractRequestNameMessageCell: BaseTableNibCell, NibLoadable {

    @IBOutlet private weak var attentionView: ParameterizedAttentionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    internal func configure(attentionMessage: ParameterizedAttentionMessage) {
        attentionView.configure(with: attentionMessage, urlOpener: PackageConstants.urlOpener)
    }
}
