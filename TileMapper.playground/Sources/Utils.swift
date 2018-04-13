import UIKit
import CoreGraphics
import AVFoundation

public class TMUtils {
    public static func constraintEdges(of view: UIView,to superView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    public static var numberOfSquaresInRow: Int?
    public static var numberOfSquaresInColumn: Int?
    public static var sizeOfEachSquare: Int? = 32
    
    public static var currentImage: UIImage?
    
    public static var eraseImage: UIImage?
    
    public static var tileFamilies: [TileFamily]?
    
    public static var canvasLayers: [CanvasDrawer]?
    
    public static var playgroundSharedDataDirectory: URL?
    
    public static let defaultCutSize: CGSize = CGSize(width: 32, height: 32)
    
    public static var audioPlayer = AVAudioPlayer()
    
    public static var canvasSizeForLayers: CGSize {
        get {
            return CGSize(width: TMUtils.numberOfSquaresInColumn!*TMUtils.sizeOfEachSquare!,height: TMUtils.numberOfSquaresInRow!*TMUtils.sizeOfEachSquare!)
        }
    }
    
    public static var canvasRectForLayers: CGRect {
        get {
            
            return CGRect(x: 0, y: 0, width: TMUtils.numberOfSquaresInColumn!*TMUtils.sizeOfEachSquare!, height: TMUtils.numberOfSquaresInRow!*TMUtils.sizeOfEachSquare!)
        }
    }
    
    public static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public static func applyAlphaFor(image: UIImage, alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(image.cgImage!, in: area)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public static func crop(thatImage image: UIImage,at point: CGPoint,with size: CGSize) -> UIImage? {
        return UIImage(cgImage: (image.cgImage?.cropping(to: CGRect(x: point.x, y: point.y, width: size.width, height: size.height)))!)
    }
    
    public static func animateWithMaterial(time: TimeInterval, delay: TimeInterval = 0.0, animationBlock: @escaping () -> Void, completionBlock: ((Bool) -> Void)? = nil) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        
        UIView.animate(withDuration: time, delay: delay, animations: animationBlock, completion: completionBlock)
        
        CATransaction.commit()
    }
    
    public static func initializeTileFamiliesFromResources() {
        
        var array = [TileFamily]()
        
        var whispersOfAvalonImages = [UIImage]()
        whispersOfAvalonImages.append(UIImage(named: "cliff.png")!)
        whispersOfAvalonImages.append(UIImage(named: "ground.png")!)
        whispersOfAvalonImages.append(UIImage(named: "objects.png")!)
//        whispersOfAvalonImages.append(UIImage(named: "unfinished-stuff.png")!)
        whispersOfAvalonImages.append(UIImage(named: "waterfall.png")!)
        array.append(TileFamily(familyName: "Whispers Of Avalon", names: ["Cliff","Ground","Objects","Unfinished stuff","Waterfall"], images: whispersOfAvalonImages))
        
        
        var artBatchImages = [UIImage]()
        artBatchImages.append(UIImage(named: "batch-1.png")!)
        artBatchImages.append(UIImage(named: "batch-2.png")!)
        artBatchImages.append(UIImage(named: "batch-3.png")!)
        artBatchImages.append(UIImage(named: "batch-4.png")!)
        array.append(TileFamily(familyName: "Art Batch", names: ["Batch 1","Batch 2","Batch 3","Batch 4"], images: artBatchImages))
        
        
        var sciFiImages = [UIImage]()
        sciFiImages.append(UIImage(named: "sci-fi-world-tileset")!)
        array.append(TileFamily(familyName: "Sci-Fi World", names: ["Sci-Fi set"], images: sciFiImages))
        
        TMUtils.tileFamilies = array
    }
    
    public static func convert(point: CGPoint, toThaDividableBy number:CGFloat) -> CGPoint {
        let pointToConvert = point
        
        let xRemainder = pointToConvert.x.truncatingRemainder(dividingBy: number)
        
        let yRemainder = pointToConvert.y.truncatingRemainder(dividingBy: number)
        
        var x:CGFloat = 0.0
        
        if (xRemainder == 0) {
            x = pointToConvert.x
        } else {
            x = pointToConvert.x - xRemainder
        }
        
        var y:CGFloat = 0
        
        if (yRemainder == 0) {
            y = pointToConvert.y
        } else {
            y = pointToConvert.y - yRemainder
        }
        
        let convertedPoint = CGPoint(x: x, y: y)
        
        return convertedPoint
    }
    
    public static func convertIndexPathToArrayIndex(from indexPath: IndexPath) -> Int {
        return (((TMUtils.canvasLayers?.count ?? 0) - 1) - indexPath.item)
    }
    
    public static func initializeLayers() {
        TMUtils.canvasLayers = [CanvasDrawer]()
        addNewLayerOnTop()
    }
    
    public static func addNewLayerOnTop() {
        TMUtils.canvasLayers?.append(CanvasDrawer(frame: TMUtils.canvasRectForLayers))
    }
    
    public static func playAudioInLoop() {
        do {
            let url = URL(string: Bundle.main.path(forResource: "background", ofType: "mp3")!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            TMUtils.audioPlayer = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
            TMUtils.audioPlayer.volume = 1
            TMUtils.audioPlayer.numberOfLoops = -1
            TMUtils.audioPlayer.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    public static func muteAudio() {
        TMUtils.audioPlayer.volume = 0
    }
    
    public static func unmuteAudio() {
        TMUtils.audioPlayer.volume = 1
    }
}

public class TileFamily {
    public var familyName: String
    public var pathForTileFamily: URL?
    public var tileSets: [TileSet]
    
    init(familyName: String, names: [String], images: [UIImage]) {
        self.familyName = familyName
        tileSets = [TileSet]()
        for (index, image) in images.enumerated() {
            tileSets.append(TileSet(tileSetName: names[index],original: image))
        }
    }
}

public class TileSet {
    public var tileSetName: String
    public var originalImage: UIImage
    public var tiles: [[Tile]]
    
    public init(tileSetName: String, original: UIImage) {
        self.tileSetName = tileSetName
        self.originalImage = original
        self.tiles = [[Tile]]()
        self.tiles = self.getTiles(image: self.originalImage, squareSize: TMUtils.defaultCutSize)
    }
    
    public func getTiles(image: UIImage?, squareSize: CGSize) -> [[Tile]] {
        var tiles: [[Tile]]!
        if let image = image {
            tiles = [[Tile]]()
            let imageHeight = image.cgImage?.height ?? 0
            let imageWidth = image.cgImage?.width ?? 0
            for rows in stride(from: 0, through: imageHeight, by: Int(squareSize.width)) {
                var tilesRow = [Tile]()
                for columns in stride(from: 0, through: imageWidth, by: Int(squareSize.height)) {
                    if imageWidth - columns > Int(squareSize.width) && imageHeight - rows > Int(squareSize.height) {
                        let image = UIImage(cgImage: (image.cgImage?.cropping(to: CGRect(x: columns, y: rows, width: Int(squareSize.width), height: Int(squareSize.height))))!)
                        tilesRow.append(Tile(image: image, size: squareSize))
                    }
                }
                tiles.append(tilesRow)
            }
        }
        return tiles
    }
    
}

public class Tile {
    public var size: CGSize!
    public var image: UIImage!
    
    public init(image: UIImage, size: CGSize) {
        self.size = size
        self.image = image
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

