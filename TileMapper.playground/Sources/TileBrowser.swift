import UIKit

public protocol TileBrowserViewDelegate {
    func didSelectTileFamily(at indexPath: IndexPath)
}

protocol TileSetCellDelegate {
    func choseTile(at indexPath: IndexPath, at point: CGPoint)
}

public class TileBrowserView: UIView {
    
    public var constraintLeftRight: NSLayoutConstraint?
    public var constraintLeftLeft: NSLayoutConstraint?
    public var constraintRightRight: NSLayoutConstraint?
    
    var backButton: UIButton!
    
    var currentImageView: UIImageView!
    
    var openFamilyBrowser: UIButton!
    
    var tileLabel: UILabel!
    
    var tileFamilyBrowser: TileFamilyBrowser!
    
    var delegate: MainViewDelegate?

    var tileSetBrowserCollectionView: UICollectionView!
    var tileSetBrowserCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var currentFamilyTile: TileFamily?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        if currentFamilyTile == nil {
            currentFamilyTile = TMUtils.tileFamilies![0]
        }
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        backButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        backButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.addTarget(self, action: #selector(self.hideViewClick(_:)), for: .touchUpInside)
        
        currentImageView = UIImageView()
        currentImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(currentImageView)
        currentImageView.topAnchor.constraint(equalTo: self.backButton.topAnchor).isActive = true
        currentImageView.bottomAnchor.constraint(equalTo: self.backButton.bottomAnchor).isActive = true
        currentImageView.heightAnchor.constraint(equalTo: self.backButton.heightAnchor).isActive = true
        currentImageView.widthAnchor.constraint(equalTo: self.currentImageView.widthAnchor, multiplier: 1.0).isActive = true
        currentImageView.rightAnchor.constraint(equalTo: self.backButton.leftAnchor, constant: -8).isActive = true
        currentImageView.image = TMUtils.currentImage
        currentImageView.layer.borderWidth = 1.5
        currentImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        openFamilyBrowser = UIButton()
        openFamilyBrowser.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(openFamilyBrowser)
        openFamilyBrowser.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        openFamilyBrowser.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        openFamilyBrowser.addTarget(self, action: #selector(self.showTileFamilyBrowser(_:)), for: .touchUpInside)
        
        tileLabel = UILabel()
        tileLabel.text = currentFamilyTile!.familyName
        tileLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tileLabel)
        tileLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tileLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        tileLabel.rightAnchor.constraint(equalTo: self.backButton.leftAnchor, constant: -16).isActive = true
        tileLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        tileFamilyBrowser = TileFamilyBrowser()
        self.addSubview(tileFamilyBrowser)
        tileFamilyBrowser.delegate = self
        tileFamilyBrowser.translatesAutoresizingMaskIntoConstraints = false
        tileFamilyBrowser.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tileFamilyBrowser.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tileFamilyBrowser.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35).isActive = true
        
        tileFamilyBrowser.constraintRightRight = tileFamilyBrowser.rightAnchor.constraint(equalTo: self.rightAnchor)
        tileFamilyBrowser.constraintRightRight?.priority = UILayoutPriority(rawValue: 1)
        
        tileFamilyBrowser.constraintLeftRight = tileFamilyBrowser.leftAnchor.constraint(equalTo: self.rightAnchor)
        tileFamilyBrowser.constraintLeftRight?.priority = UILayoutPriority(rawValue: 999)
        
        tileFamilyBrowser.constraintRightRight?.isActive = true
        tileFamilyBrowser.constraintLeftRight?.isActive = true
        
        tileSetBrowserCollectionViewFlowLayout = UICollectionViewFlowLayout()
        tileSetBrowserCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tileSetBrowserCollectionViewFlowLayout)
        if let flowLayout = tileSetBrowserCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        tileSetBrowserCollectionView.tag = 1
        tileSetBrowserCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(tileSetBrowserCollectionView, belowSubview: backButton)
        tileSetBrowserCollectionView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tileSetBrowserCollectionView.topAnchor.constraint(equalTo: self.tileLabel.bottomAnchor).isActive = true
        tileSetBrowserCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tileSetBrowserCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tileSetBrowserCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        tileSetBrowserCollectionView.delegate = self
        tileSetBrowserCollectionView.dataSource = self
        
        tileSetBrowserCollectionView.register(TileSetCell.self, forCellWithReuseIdentifier: TileSetCell.identifier)
        setNeedsLayout()
    }
    
    public func showView() {
        let animationBlock: () -> Void = { [weak self] in
            self?.constraintRightRight?.priority = UILayoutPriority(rawValue: 999)
            self?.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 999)
            self?.constraintLeftRight?.priority = UILayoutPriority(rawValue: 1)
            self?.superview?.layoutIfNeeded()
        }
        
        TMUtils.animateWithMaterial(time: 0.375, delay: 0.0, animationBlock: animationBlock)
    }
    
    @objc func hideViewClick(_ button: UIButton) {self.hideView()}
    
    public func hideView() {
        
        let animationBlock: () -> Void = { [weak self] in
            self?.constraintRightRight?.priority = UILayoutPriority(rawValue: 1)
            self?.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 1)
            self?.constraintLeftRight?.priority = UILayoutPriority(rawValue: 999)
            self?.superview?.layoutIfNeeded()
        }
        
        TMUtils.animateWithMaterial(time: 0.375, delay: 0.0, animationBlock: animationBlock)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = 5
        backButton.clipsToBounds = true
        
        openFamilyBrowser.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        openFamilyBrowser.setImage(UIImage(named: "list-of-three-items-with-squares-and-lines"), for: .normal)
        openFamilyBrowser.imageView?.contentMode = .scaleAspectFit
        openFamilyBrowser.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        openFamilyBrowser.layer.cornerRadius = 0.5 * openFamilyBrowser.bounds.size.width
        openFamilyBrowser.clipsToBounds = true
    }
    
    @objc func showTileFamilyBrowser(_ button: UIButton) {
        tileFamilyBrowser.showView()
    }
}


extension TileBrowserView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemImage = currentFamilyTile!.tileSets[indexPath.item].originalImage
        let myImageWidth = itemImage.size.width
        let myImageHeight = itemImage.size.height
        let myViewWidth = collectionView.bounds.width
        
        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio
        return CGSize(width: collectionView.bounds.width, height: scaledHeight + CGFloat(TileSetCell.spacingBetweenImageAndTitle + TileSetCell.labelHeight + TileSetCell.labelTopSpacing))

    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileSetCell.identifier, for: indexPath)
        if let cell = cell as? TileSetCell {
            cell.indexPath = indexPath
            cell.delegate = self
            cell.setDisplayData(tileSet: currentFamilyTile!.tileSets[indexPath.item])
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFamilyTile!.tileSets.count
    }
    
}

extension TileBrowserView: TileBrowserViewDelegate {
    public func didSelectTileFamily(at indexPath: IndexPath) {
        currentFamilyTile = TMUtils.tileFamilies![indexPath.item]
        tileLabel.text = currentFamilyTile?.familyName ?? ""
        self.tileSetBrowserCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.tileSetBrowserCollectionView.reloadData()
    }
}

extension TileBrowserView: TileSetCellDelegate {
    func choseTile(at indexPath: IndexPath, at point: CGPoint) {
        self.delegate?.didSelectNewTile(from: self.currentFamilyTile!, using: currentFamilyTile!.tileSets[indexPath.item], at: point)
        self.currentImageView.image = TMUtils.currentImage
        self.hideView()
    }
}

class TileSetCell: UICollectionViewCell {
    
    var label: UILabel!
    var tileSetImage: ResizableHeightUIImageView!
    var gridView: GridView!
    
    var tapGesture: UITapGestureRecognizer!
    
    var indexPath: IndexPath!
    
    var delegate: TileSetCellDelegate?
    
    static let labelHeight = 32
    
    static let labelTopSpacing = 12
    
    static let spacingBetweenImageAndTitle = 8
    
    static let identifier = "TileSetCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        label = UILabel()
        tileSetImage = ResizableHeightUIImageView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(TileSetCell.labelTopSpacing)).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        label.heightAnchor.constraint(equalToConstant: CGFloat(TileSetCell.labelHeight)).isActive = true
        
        
        tileSetImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(tileSetImage)
        tileSetImage.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: CGFloat(TileSetCell.spacingBetweenImageAndTitle)).isActive = true
        tileSetImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tileSetImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tileSetImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tileSetImage.contentMode = .scaleAspectFill
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        tileSetImage.addGestureRecognizer(tapGesture)
        tileSetImage.isUserInteractionEnabled = true
        
        
        
        gridView = GridView()

        self.tileSetImage.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.topAnchor.constraint(equalTo: self.tileSetImage.topAnchor, constant: 0.0).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.tileSetImage.bottomAnchor, constant: 0.0).isActive = true
        gridView.leftAnchor.constraint(equalTo: self.tileSetImage.leftAnchor, constant: 0.0).isActive = true
        gridView.rightAnchor.constraint(equalTo: self.tileSetImage.rightAnchor, constant: 0.0).isActive = true
        gridView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 0)
    }
    
    @objc func handleImageTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let myImageWidth = tileSetImage.image!.size.width
        let myViewWidth = self.tileSetImage.bounds.width
        
        let ratio = myViewWidth/myImageWidth
        
        let pointToConvert = gestureRecognizer.location(in: self.tileSetImage)
        var convertedPoint = TMUtils.convert(point: pointToConvert, toThaDividableBy: 32*ratio)
        convertedPoint = CGPoint(x: convertedPoint.x/ratio, y: convertedPoint.y/ratio)
        delegate?.choseTile(at: indexPath, at: convertedPoint)
    }
    
    func setDisplayData(tileSet: TileSet) {
        label.text = tileSet.tileSetName
        tileSetImage.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        tileSetImage.image = tileSet.originalImage
        
        
        let itemImage = tileSet.originalImage
        let myImageWidth = itemImage.size.width
        let myViewWidth = self.bounds.width
        
        let ratio = myViewWidth/myImageWidth
        
        gridView.gridSize = 32*ratio
        
        gridView.setNeedsDisplay()
        
        
    }
    
}
