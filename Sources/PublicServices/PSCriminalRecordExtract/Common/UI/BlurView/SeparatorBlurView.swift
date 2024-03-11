import UIKit
import DiiaUIComponents

class SeparatorBlurView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var blurView: UIView!
    
    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            Constants.startGradientColor,
            Constants.endGradientColor
        ]
        gradient.locations = [0, 1]
        gradient.frame = blurView.frame
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: contentView.frame.width,
                height: contentView.frame.height - Constants.separatorHeight
            )
        )
    }
    
    private func commonInit() {
        fromNib(bundle: Bundle.module)
        setupContentView()
        setupBlurView()
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
    
    private func setupBlurView() {
        blurView.layer.addSublayer(gradient)
    }
}

private extension SeparatorBlurView {
    enum Constants {
        static let startGradientColor = UIColor(hex6: 0xE2ECF4, alpha: 0.0).cgColor
        static let endGradientColor = UIColor(hex6: 0xE2ECF4, alpha: 1.0).cgColor
        static let separatorHeight = 2.0
    }
}
