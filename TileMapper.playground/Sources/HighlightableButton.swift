import UIKit

class HighlightableButton: UIButton {
    override var isSelected: Bool{
        set {
            
            let animationBlock: () -> Void = { [weak self] in
                self?.alpha = newValue ? 0.5 : 1
                self?.transform = newValue ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
            
            TMUtils.animateWithMaterial(time: 0.1, delay: 0.0, animationBlock: animationBlock)

            super.isHighlighted = newValue
        } get {
            return super.isHighlighted
        }
    }
}
