import UIKit

protocol CanvasViewDelegate {
    func didAddLayerOnTop()
    
    func changedCurrentLayer(newLayerIndex index: Int)
    
    func didClickLockForLayer(at index: IndexPath)
    
    func didClickHideForLayer(at index: IndexPath)
    
    func didClickDeleteForLayer(at index: IndexPath)
}

public class CanvasView: UIView {
    
    var layers: [CanvasDrawer]!
    var layerView: UIView!
    
    var currentLayer: Int = 0
    
    var buttonsStackView: UIStackView!
    
    var brushModeButton: HighlightableButton!
    var eraseModeButton: HighlightableButton!
    var panModeButton: HighlightableButton!
    var historyViewerButton: HighlightableButton!
    var currentTile: UIImageView!
    
    var scrollableCanvas: UIScrollView!
    
    var panGesture: UILongPressGestureRecognizer!
    
    public enum CanvasMode {
        case brush
        case erase
        case pan
    }

    var currentCanvasMode = CanvasMode.brush {
        didSet {
            switch currentCanvasMode {
            case .pan:
                scrollabelLayer.removeGestureRecognizer(panGesture)
                scrollabelLayer.isScrollEnabled = true
                panModeButton.isSelected = true
                brushModeButton.isSelected = false
                eraseModeButton.isSelected = false
            case .erase:
                scrollabelLayer.addGestureRecognizer(panGesture)
                scrollabelLayer.isScrollEnabled = false
                panModeButton.isSelected = false
                brushModeButton.isSelected = false
                eraseModeButton.isSelected = true
            case .brush:
                scrollabelLayer.addGestureRecognizer(panGesture)
                scrollabelLayer.isScrollEnabled = false
                panModeButton.isSelected = false
                brushModeButton.isSelected = true
                eraseModeButton.isSelected = false
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }

    var scrollabelLayer: UIScrollView!
    
    var gridView: GridView!
    
    func initViews() {
        layers = TMUtils.canvasLayers
        
        scrollabelLayer = UIScrollView()
        layerView = UIView()
        scrollabelLayer.contentSize = TMUtils.canvasSizeForLayers
        scrollabelLayer.minimumZoomScale = 0.5
        scrollabelLayer.maximumZoomScale = 2.0
        scrollabelLayer.delegate = self
        scrollabelLayer.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.2745098039, blue: 0.2823529412, alpha: 1)
        self.addSubview(scrollabelLayer)
        scrollabelLayer.addSubview(layerView)
        gridView = GridView()
        gridView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        layerView.addSubview(gridView)
        gridView.frame = CGRect(x: 0, y: 0, width: scrollabelLayer.contentSize.width, height: scrollabelLayer.contentSize.height)
        layerView.frame = CGRect(x: 0, y: 0, width: scrollabelLayer.contentSize.width, height: scrollabelLayer.contentSize.height)
        TMUtils.constraintEdges(of: scrollabelLayer, to: self)
        
        for layer in layers {
            layer.translatesAutoresizingMaskIntoConstraints = false
            layer.frame = TMUtils.canvasRectForLayers
            self.layerView.addSubview(layer)
        }
        
        self.panGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.panGesture.numberOfTouchesRequired = 1
        self.panGesture.minimumPressDuration = 0

        
        brushModeButton = HighlightableButton()
        eraseModeButton = HighlightableButton()
        panModeButton = HighlightableButton()
        historyViewerButton = HighlightableButton()
        currentTile = UIImageView()
        currentTile.layer.borderWidth = 1.5
        currentTile.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        currentTile.isUserInteractionEnabled = true
        
        currentTile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showTileBrowser(_:))))
        
        buttonsStackView = UIStackView()
        currentTile.image = TMUtils.currentImage
        self.buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonsStackView)
        
        self.buttonsStackView.addArrangedSubview(currentTile)
        self.buttonsStackView.addArrangedSubview(brushModeButton)
        self.buttonsStackView.addArrangedSubview(eraseModeButton)
        self.buttonsStackView.addArrangedSubview(panModeButton)
        
        buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        buttonsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .center
        buttonsStackView.spacing = 10
        
        setNeedsDisplay()
        
        
        brushModeButton.addTarget(self, action: #selector(self.enableBrushMode(_:)), for: .touchUpInside)
        eraseModeButton.addTarget(self, action: #selector(self.enableEraseMode(_:)), for: .touchUpInside)
        panModeButton.addTarget(self, action: #selector(self.enablePanMode(_:)), for: .touchUpInside)
        
    }
    
    @objc func showTileBrowser(_ sender: UIButton) {
        if let superViewOfCurrent = self.superview as? MainView {
            superViewOfCurrent.tileBrowser.showView()
        }
    }
    
    @objc func enableBrushMode(_ sender: UIButton) {
        currentCanvasMode = CanvasMode.brush
    }
    
    @objc func enableEraseMode(_ sender: UIButton) {
        currentCanvasMode = CanvasMode.erase
    }
    
    @objc func enablePanMode(_ sender: UIButton) {
        currentCanvasMode = CanvasMode.pan
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {

        let pointToConvert = gestureRecognizer.location(in: layers[currentLayer])
        
        let convertedPoint = TMUtils.convert(point: pointToConvert, toThaDividableBy: 32)

        if (!layers[currentLayer].isLocked) {
            switch currentCanvasMode {
            case .pan:
                break
            case .erase:
                layers[currentLayer].eraseMode = true
            case .brush:
                layers[currentLayer].eraseMode = false
            }
            layers[currentLayer].setNeedsDisplay(CGRect(x: convertedPoint.x, y: convertedPoint.y, width: 32, height: 32))
        }
    }
    
    
    
    
    func changeMode(to canvasMode: CanvasMode) {
        
    }
    
    public override func layoutSubviews() {
        
        historyViewerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        historyViewerButton.setImage(UIImage(named: "history"), for: .normal)
        historyViewerButton.imageView?.contentMode = .scaleAspectFit
        historyViewerButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 2)
        historyViewerButton.layer.cornerRadius = 0.5 * historyViewerButton.bounds.size.width
        historyViewerButton.clipsToBounds = true
        
        brushModeButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        brushModeButton.setImage(UIImage(named: "paint-brush-32"), for: .normal)
        brushModeButton.imageView?.contentMode = .scaleAspectFit
        brushModeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        brushModeButton.layer.cornerRadius = 0.5 * brushModeButton.bounds.size.width
        brushModeButton.clipsToBounds = true
        
        eraseModeButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        eraseModeButton.setImage(UIImage(named: "double-sided-eraser"), for: .normal)
        eraseModeButton.imageView?.contentMode = .scaleAspectFit
        eraseModeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        eraseModeButton.layer.cornerRadius = 0.5 * eraseModeButton.bounds.size.width
        eraseModeButton.clipsToBounds = true
        
        panModeButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        panModeButton.setImage(UIImage(named: "move"), for: .normal)
        panModeButton.imageView?.contentMode = .scaleAspectFit
        panModeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        panModeButton.layer.cornerRadius = 0.5 * panModeButton.bounds.size.width
        panModeButton.clipsToBounds = true
        
        
        panModeButton.isSelected = true
        brushModeButton.isSelected = false
        eraseModeButton.isSelected = false
    }

}

extension CanvasView: CanvasViewDelegate {
    func didClickLockForLayer(at index: IndexPath) {
        
        let index = TMUtils.convertIndexPathToArrayIndex(from: index)
        
        if (TMUtils.canvasLayers![index].isLocked) {
            TMUtils.canvasLayers![index].isLocked = false
        } else {
            TMUtils.canvasLayers![index].isLocked = true
        }
    }
    
    func didClickHideForLayer(at index: IndexPath) {
        
        let index = TMUtils.convertIndexPathToArrayIndex(from: index)
        
        if (TMUtils.canvasLayers![index].isHidden) {
            TMUtils.canvasLayers![index].isHidden = false
        } else {
            TMUtils.canvasLayers![index].isHidden = true
        }
    }
    
    func didClickDeleteForLayer(at index: IndexPath) {
        if currentLayer == index.item && currentLayer == ((TMUtils.canvasLayers?.count ?? 0) - 1) {
            currentLayer = currentLayer - 1
        }
    }

    func didAddLayerOnTop() {
        layers = TMUtils.canvasLayers
        let latestLayer = TMUtils.canvasLayers!.last!
        latestLayer.translatesAutoresizingMaskIntoConstraints = false
        latestLayer.frame = TMUtils.canvasRectForLayers
        self.layerView.addSubview(latestLayer)
    }
    
    func changedCurrentLayer(newLayerIndex index: Int) {
        self.currentLayer = ((TMUtils.canvasLayers!.count - 1) - index)
        print(self.currentLayer)
    }
}

extension CanvasView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.layerView
    }
}
