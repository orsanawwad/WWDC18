import UIKit

protocol MainViewDelegate {
    func didSelectNewTile(from family: TileFamily, using set: TileSet, at point: CGPoint)
}

public class MainView: UIView {
    
    var canvasView: CanvasView!
    var panGesture: UIPanGestureRecognizer!
    
    var layerBrowserShowButton: UIButton!
    
    var tileSetBrowserShowButton: UIButton!
    
    var muteButton: HighlightableButton!
    
    var tileBrowser: TileBrowserView!
    
    var layerBrowser: LayerBrowser!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        canvasView = CanvasView()

        self.addSubview(canvasView)
        TMUtils.constraintEdges(of: canvasView, to: self)

        tileSetBrowserShowButton = UIButton()
        tileSetBrowserShowButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tileSetBrowserShowButton)
        tileSetBrowserShowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tileSetBrowserShowButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        tileSetBrowserShowButton.addTarget(self, action: #selector(self.showTileBrowser(_:)), for: .touchUpInside)
        
        layerBrowserShowButton = UIButton()
        layerBrowserShowButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(layerBrowserShowButton)
        layerBrowserShowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        layerBrowserShowButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        layerBrowserShowButton.addTarget(self, action: #selector(self.showLayerBrowser(_:)), for: .touchUpInside)
        
  
        muteButton = HighlightableButton()
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(muteButton)
        muteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        muteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        muteButton.addTarget(self, action: #selector(self.muteMusic(_:)), for: .touchUpInside)
        muteButton.isSelected = false
        
        
        layerBrowser = LayerBrowser()
        layerBrowser.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(layerBrowser)
        layerBrowser.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        layerBrowser.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        layerBrowser.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        
        layerBrowser.constraintLeftLeft = layerBrowser.leftAnchor.constraint(equalTo: self.leftAnchor)
        layerBrowser.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 1)
        
        layerBrowser.constraintRightLeft = layerBrowser.rightAnchor.constraint(equalTo: self.leftAnchor)
        layerBrowser.constraintRightLeft?.priority = UILayoutPriority(rawValue: 999)

        layerBrowser.constraintLeftLeft?.isActive = true
        layerBrowser.constraintRightLeft?.isActive = true
        
        layerBrowser.delegate = canvasView
        
        
        tileBrowser = TileBrowserView()
        tileBrowser.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tileBrowser.translatesAutoresizingMaskIntoConstraints = false
        tileBrowser.delegate = self
        self.addSubview(tileBrowser)
        tileBrowser.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tileBrowser.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tileBrowser.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        
        tileBrowser.constraintLeftLeft = tileBrowser.leftAnchor.constraint(equalTo: self.leftAnchor)
        tileBrowser.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 1)
        
        tileBrowser.constraintRightRight = tileBrowser.rightAnchor.constraint(equalTo: self.rightAnchor)
        tileBrowser.constraintRightRight?.priority = UILayoutPriority(rawValue: 1)
        
        tileBrowser.constraintLeftRight = tileBrowser.leftAnchor.constraint(equalTo: self.rightAnchor)
        tileBrowser.constraintLeftRight?.priority = UILayoutPriority(rawValue: 999)
        
        tileBrowser.constraintLeftLeft?.isActive = true
        tileBrowser.constraintRightRight?.isActive = true
        tileBrowser.constraintLeftRight?.isActive = true
        
        self.layoutIfNeeded()
    }
    
    @objc func showTileBrowser(_ button: UIButton) {
        tileBrowser.showView()
    }
    
    @objc func showLayerBrowser(_ button: UIButton) {
        layerBrowser.showView()
    }
    
    @objc func muteMusic(_ button: UIButton) {
        if TMUtils.audioPlayer.volume == 1 {
            muteButton.isSelected = true
            TMUtils.muteAudio()
        } else {
            muteButton.isSelected = false
            TMUtils.unmuteAudio()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        tileSetBrowserShowButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        tileSetBrowserShowButton.setImage(UIImage(named: "squares-of-data"), for: .normal)
        tileSetBrowserShowButton.imageView?.contentMode = .scaleAspectFit
        tileSetBrowserShowButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        tileSetBrowserShowButton.layer.cornerRadius = 0.5 * tileSetBrowserShowButton.bounds.size.width
        tileSetBrowserShowButton.clipsToBounds = true
        
        
        layerBrowserShowButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        layerBrowserShowButton.setImage(UIImage(named: "layers-icon"), for: .normal)
        layerBrowserShowButton.imageView?.contentMode = .scaleAspectFit
        layerBrowserShowButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        layerBrowserShowButton.layer.cornerRadius = 0.5 * layerBrowserShowButton.bounds.size.width
        layerBrowserShowButton.clipsToBounds = true
        
        
        muteButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        muteButton.setImage(UIImage(named: "volume-adjustment-mute"), for: .normal)
        muteButton.imageView?.contentMode = .scaleAspectFit
        muteButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        muteButton.layer.cornerRadius = 0.5 * muteButton.bounds.size.width
        muteButton.clipsToBounds = true
    }
    
}

extension MainView: MainViewDelegate {
    func didSelectNewTile(from family: TileFamily, using set: TileSet, at point: CGPoint) {
        let x = Int(point.x/32)
        let y = Int(point.y/32)
        
        TMUtils.currentImage = set.tiles[y][x].image
        self.canvasView.currentTile.image = TMUtils.currentImage
    }
}
