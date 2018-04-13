import UIKit


class GridView: UIView {
    public var currentTile: UIImage?
    
    private var path = UIBezierPath()
    fileprivate var gridWidthMultiple: CGFloat {
        return CGFloat(TMUtils.numberOfSquaresInColumn ?? 32)
    }
    
    fileprivate var gridHeightMultiple : CGFloat {
        return CGFloat(TMUtils.numberOfSquaresInRow ?? 32)
    }
    
    fileprivate var gridWidth: CGFloat {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat {
        return gridWidth
    }
    
    fileprivate var ration: CGFloat = 0.0
    
        
    var gridSize: CGFloat = 32
    
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid() {
        
        let gridSizeWidth = gridSize
        let gridSizeHeight = gridSize
        path = UIBezierPath()
        path.lineWidth = 0.7
        
        for index in 0...Int(gridWidthMultiple) {
            let startH = CGPoint(x: CGFloat(index) * gridSizeWidth, y: 0)
            let endH = CGPoint(x: CGFloat(index) * gridSizeWidth, y:bounds.height)
            path.move(to: startH)
            path.addLine(to: endH)
        }
        
        for index in 0...Int(gridHeightMultiple) {
            let startV = CGPoint(x: 0, y: CGFloat(index) * gridSizeHeight)
            let endV = CGPoint(x: bounds.width, y: CGFloat(index) * gridSizeHeight)
            path.move(to: startV)
            path.addLine(to: endV)
        }
        path.close()
        
    }
    
    public override func draw(_ rect: CGRect) {
        drawGrid()
        
        UIColor.white.setStroke()
        path.stroke()
    }
    
}
