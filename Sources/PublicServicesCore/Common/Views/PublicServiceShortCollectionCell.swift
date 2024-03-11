import UIKit
import DiiaUIComponents

/// design_system_code: serviceCardMlс
class PublicServiceShortCollectionCell: BaseCollectionNibCell, NibLoadable {

    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    private func setupViews() {
        nameLbl.font = FontBook.usualFont
    }
    
    func configure(with title: String, iconName: String, isActive: Bool) {
        nameLbl.text = title
        nameLbl.alpha = isActive ? Constants.withoutAlpha : Constants.halfAlpha
        
        iconView.image = PackageConstants.imageNameProvider?.imageForCode(imageCode: iconName)
        iconView.alpha = isActive ? Constants.withoutAlpha : Constants.halfAlpha
    }
}

extension PublicServiceShortCollectionCell {
    private enum Constants {
        static let halfAlpha: CGFloat = 0.5
        static let withoutAlpha: CGFloat = 1
    }
}
