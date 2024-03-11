import UIKit
import DiiaUIComponents

public class ShadowView: UIView {
    
    public override var bounds: CGRect {
        didSet {
            setupShadow(
                color: color,
                alpha: shadowAlpha,
                x: x,
                y: y,
                blur: blur,
                spread: spread
            )
        }
    }
    
    private var color: UIColor = .black
    private var shadowAlpha: Float = .zero
    private var x: CGFloat = .zero
    private var y: CGFloat = .zero
    private var blur: CGFloat = .zero
    private var spread: CGFloat = .zero
    
    public func setupShadow(
        color: UIColor = UIColor("#16222E29"),
        alpha: Float = 0.16,
        x: CGFloat = 0,
        y: CGFloat = 25,
        blur: CGFloat = 16,
        spread: CGFloat = 20
    ) {
        self.color = color
        self.shadowAlpha = alpha
        self.x = x
        self.y = y
        self.blur = blur
        self.spread = spread
        
        layer.clearShadows()
        layer.applySketchShadow(
            color: self.color,
            alpha: self.shadowAlpha,
            x: self.x,
            y: self.y,
            blur: self.blur,
            spread: self.spread
        )
    }
}
