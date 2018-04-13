import UIKit

public class TileFamilyBrowser: UIView {
    
    public var constraintLeftRight: NSLayoutConstraint?
    public var constraintRightRight: NSLayoutConstraint?
    
    var tileFamilyBrowserCollectionView: UICollectionView!
    var tileFamilyBrowserCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var title: UILabel!
    
    var backButton: UIButton!
    
    var delegate: TileBrowserViewDelegate?  
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        
        backgroundColor = #colorLiteral(red: 0.6816619039, green: 0.6776120067, blue: 0.684776485, alpha: 1)
        
        title = UILabel()
        title.text = "Choose tile family"
        title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        backButton = UIButton(type: .system)
        backButton.setTitle("✖️", for: .normal)
        backButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        backButton.addTarget(self, action: #selector(self.hideViewClick(_:)), for: .touchUpInside)
        
        tileFamilyBrowserCollectionViewFlowLayout = UICollectionViewFlowLayout()
        tileFamilyBrowserCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tileFamilyBrowserCollectionViewFlowLayout)
        tileFamilyBrowserCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(tileFamilyBrowserCollectionView, belowSubview: backButton)
        tileFamilyBrowserCollectionView.backgroundColor = #colorLiteral(red: 0.3563512564, green: 0.3542381525, blue: 0.35797894, alpha: 1)
        tileFamilyBrowserCollectionView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 10).isActive = true
        tileFamilyBrowserCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tileFamilyBrowserCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tileFamilyBrowserCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        tileFamilyBrowserCollectionView.delegate = self
        tileFamilyBrowserCollectionView.dataSource = self
        
        tileFamilyBrowserCollectionView.register(TileFamilyPickerCell.self, forCellWithReuseIdentifier: TileFamilyPickerCell.identifier)
    }
    
    public func showView() {
        let animationBlock: () -> Void = { [weak self] in
            self?.constraintRightRight?.priority = UILayoutPriority(rawValue: 999)
            self?.constraintLeftRight?.priority = UILayoutPriority(rawValue: 1)
            self?.superview?.layoutIfNeeded()
        }
        
        TMUtils.animateWithMaterial(time: 0.225, delay: 0.0, animationBlock: animationBlock)
    }
    
    @objc func hideViewClick(_ button: UIButton) {self.hideView()}
    
    public func hideView() {
        
        let animationBlock: () -> Void = { [weak self] in
            self?.constraintRightRight?.priority = UILayoutPriority(rawValue: 1)
            self?.constraintLeftRight?.priority = UILayoutPriority(rawValue: 999)
            self?.superview?.layoutIfNeeded()
        }
        
        TMUtils.animateWithMaterial(time: 0.225, delay: 0.0, animationBlock: animationBlock)
    }
    
}

extension TileFamilyBrowser: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileFamilyPickerCell.identifier, for: indexPath)
        if let cell = cell as? TileFamilyPickerCell {
            cell.setDisplayData(tileFamily: TMUtils.tileFamilies![indexPath.item])
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TMUtils.tileFamilies?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectTileFamily(at: indexPath)
    }
    
}


class TileFamilyPickerCell: UICollectionViewCell {
    var tilesLabel: UILabel!
    var imageFamilyTile: UIImageView!
    
    static let identifier = "TileFamilyPickerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        backgroundColor = #colorLiteral(red: 0.2184121907, green: 0.2194295824, blue: 0.2218931019, alpha: 1)
        tilesLabel = UILabel()
        tilesLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.addSubview(tilesLabel)
        tilesLabel.translatesAutoresizingMaskIntoConstraints = false
        tilesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        tilesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        tilesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        tilesLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        imageFamilyTile = UIImageView()
        self.contentView.addSubview(imageFamilyTile)
        imageFamilyTile.translatesAutoresizingMaskIntoConstraints = false
        imageFamilyTile.topAnchor.constraint(equalTo: self.tilesLabel.bottomAnchor, constant: 6).isActive = true
        imageFamilyTile.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageFamilyTile.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageFamilyTile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        imageFamilyTile.contentMode = .scaleAspectFit
    }
    
    func setDisplayData(tileFamily: TileFamily) {
        tilesLabel.text = tileFamily.familyName
        imageFamilyTile.image = tileFamily.tileSets[0].originalImage
        setNeedsDisplay()
    }
    
}
