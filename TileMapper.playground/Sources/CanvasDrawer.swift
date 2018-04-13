import UIKit

public class CanvasDrawer: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    var isLocked: Bool = false
    
    public var eraseMode: Bool = false
    
    public override func draw(_ rect: CGRect) {
        if isLocked == false {
            if rect.equalTo(self.frame) {
                return
            }
            else if eraseMode {
                if let image = TMUtils.currentImage {
                    image.draw(at: CGPoint(x: rect.minX, y: rect.minY), blendMode: .copy, alpha: 0.0)
                }
            }
            else if let image = TMUtils.currentImage {
                image.draw(at: CGPoint(x: rect.minX, y: rect.minY), blendMode: .copy, alpha: 1.0)
            }
        } else {
            return
        }
    }

    func isLayerVisible() -> Bool {
        return self.isHidden
    }
    
    func isLayerLocked() -> Bool {
        return self.isLocked
    }

    func unhideLayer() -> Bool {
        self.isHidden = false
        return self.isHidden
    }
    
    func hideLayer() -> Bool{
        self.isHidden = true
        return self.isHidden
    }
    
    func unlockLayer() -> Bool{
        self.isLocked = false
        return self.isLocked
    }
    
    func lockLayer() -> Bool{
        self.isLocked = true
        return self.isLocked
    }
    
}
