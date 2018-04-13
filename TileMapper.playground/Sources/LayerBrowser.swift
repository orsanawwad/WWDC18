import UIKit

protocol LayerBrowserProtocol {
    func layerClickedDelete(at indexPath: IndexPath)
    
    func layerClickedHide(at indexPath: IndexPath)
    
    func layerClickedLock(at indexPath: IndexPath)
}

public class LayerBrowser: UIView {
    
    public var constraintRightLeft: NSLayoutConstraint?
    public var constraintLeftLeft: NSLayoutConstraint?
    
    var title: UILabel!
    
    var backButton: UIButton!
    
    var addNewLayer: UIButton!
    
    var layersCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var layersCollectionView: UICollectionView!
    
    var delegate: CanvasViewDelegate?
    
    var currentSelectedCell: IndexPath? {
        didSet {
            if oldValue != nil {
                if (shouldReloadAllData) {
                    self.layersCollectionView.performBatchUpdates({
                        self.layersCollectionView.reloadSections(IndexSet(integer: 0))
                    }, completion: { (flag) in
                        self.shouldReloadAllData = false
                    })
                }
                delegate?.changedCurrentLayer(newLayerIndex: currentSelectedCell!.item)
            }
        }
    }
    
    var shouldReloadAllData = false
    
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
        title.text = "Layers"
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        backButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        backButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        backButton.addTarget(self, action: #selector(self.hideViewClick(_:)), for: .touchUpInside)
        
        
        addNewLayer = UIButton(type: .system)
        addNewLayer.setTitle("Add Layer", for: .normal)
        addNewLayer.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.addSubview(addNewLayer)
        addNewLayer.translatesAutoresizingMaskIntoConstraints = false
        addNewLayer.topAnchor.constraint(equalTo: self.title.bottomAnchor,constant: 12).isActive = true
        addNewLayer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        addNewLayer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        addNewLayer.heightAnchor.constraint(equalToConstant: 38).isActive = true
        addNewLayer.backgroundColor = #colorLiteral(red: 0.4007499218, green: 0.7320625186, blue: 0.5128623247, alpha: 1)
        addNewLayer.addTarget(self, action: #selector(self.handleAddingNewLayer(_:)), for: .touchUpInside)
        
        layersCollectionViewFlowLayout = UICollectionViewFlowLayout()
        layersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layersCollectionViewFlowLayout)
        
        layersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(layersCollectionView)
        layersCollectionView.backgroundColor = #colorLiteral(red: 0.6709677577, green: 0.6740754247, blue: 0.6816629171, alpha: 1)
        layersCollectionView.topAnchor.constraint(equalTo: self.addNewLayer.bottomAnchor, constant: 8).isActive = true
        layersCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        layersCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        layersCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        layersCollectionView.delegate = self
        layersCollectionView.dataSource = self
        
        layersCollectionView.register(LayerBrowserCell.self, forCellWithReuseIdentifier: LayerBrowserCell.identifier)
        
        
        setNeedsLayout()
    }
    
    public func showView() {
        let animationBlock: () -> Void = { [weak self] in
            self?.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 999)
            self?.constraintRightLeft?.priority = UILayoutPriority(rawValue: 1)
            self?.superview?.layoutIfNeeded()
            self?.layersCollectionView.reloadData()
        }
        
        TMUtils.animateWithMaterial(time: 0.225, delay: 0.0, animationBlock: animationBlock)
    }
    
    @objc func hideViewClick(_ button: UIButton) {self.hideView()}
    
    public func hideView() {
        
        let animationBlock: () -> Void = { [weak self] in
//            self?.constraintRightRight?.priority = UILayoutPriority(rawValue: 1)
            self?.constraintLeftLeft?.priority = UILayoutPriority(rawValue: 1)
            self?.constraintRightLeft?.priority = UILayoutPriority(rawValue: 999)
            self?.superview?.layoutIfNeeded()
        }
        
        TMUtils.animateWithMaterial(time: 0.225, delay: 0.0, animationBlock: animationBlock)
    }
    
    @objc func handleAddingNewLayer(_ button: UIButton) {
        TMUtils.addNewLayerOnTop()
        shouldReloadAllData = true
        currentSelectedCell = IndexPath(item: currentSelectedCell!.item + 1, section: currentSelectedCell!.section)
        delegate?.didAddLayerOnTop()
    }
 
    public override func layoutSubviews() {
        super.layoutSubviews()
        backButton.layer.cornerRadius = 5
        backButton.clipsToBounds = true
        
        
        addNewLayer.layer.cornerRadius = 10
        addNewLayer.clipsToBounds = true
    }
    
}

extension LayerBrowser: LayerBrowserProtocol {
    func layerClickedDelete(at indexPath: IndexPath) {
        let index = TMUtils.convertIndexPathToArrayIndex(from: indexPath)
        if TMUtils.canvasLayers?.count == 1 {
            //PREVENT
        } else {
            TMUtils.canvasLayers![index].removeFromSuperview()
            TMUtils.canvasLayers?.remove(at: index)
            if (currentSelectedCell?.item)! >= indexPath.item && (currentSelectedCell?.item)! >= TMUtils.canvasLayers!.count {
                print(IndexPath(item: currentSelectedCell!.item - 1, section: currentSelectedCell!.section))
                currentSelectedCell = IndexPath(item: currentSelectedCell!.item - 1, section: currentSelectedCell!.section)
            }
            layersCollectionView.reloadSections(IndexSet(integer: 0))
            delegate?.didClickDeleteForLayer(at: indexPath)
        }

    }
    
    func layerClickedHide(at indexPath: IndexPath) {
        delegate?.didClickHideForLayer(at: indexPath)
    }
    
    func layerClickedLock(at indexPath: IndexPath) {
        delegate?.didClickLockForLayer(at: indexPath)
    }
    
}

extension LayerBrowser: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LayerBrowserCell.identifier, for: indexPath)
        
        if let cell = cell as? LayerBrowserCell {
            shouldReloadAllData = false
            let view = TMUtils.canvasLayers![(TMUtils.canvasLayers!.count - 1) - indexPath.item]
            cell.setDisplayData(title: "Layer \((TMUtils.canvasLayers!.count - 1) - indexPath.item)", view: view,indexPath: indexPath,delegate: self,isLocked: view.isLocked, isHidden: view.isHidden)
            if currentSelectedCell == nil {
                currentSelectedCell = IndexPath(item: 0, section: 0)
                if (indexPath.item == currentSelectedCell?.item) {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                }
            }
            if (currentSelectedCell!.item == indexPath.item) {
                cell.highlightCell()
            } else {
                cell.unhighlightCell()
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TMUtils.canvasLayers?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentSelectedCell = currentSelectedCell {
            if let cell = collectionView.cellForItem(at: currentSelectedCell) as? LayerBrowserCell {
                if currentSelectedCell.item != indexPath.item {
                    cell.unhighlightCell()
                }
            }
        }
        currentSelectedCell = indexPath
        shouldReloadAllData = false
    }

}

class LayerBrowserCell: UICollectionViewCell {
    public static let identifier = "LayerBrowserCell"
    
    var layerTitle: UILabel!
    var imageOfCanvas: UIImageView!
    
    let highlightColor = #colorLiteral(red: 0.2184121907, green: 0.2194295824, blue: 0.2218931019, alpha: 1)
    let unhighlightColor = #colorLiteral(red: 0.4348061085, green: 0.432225883, blue: 0.4367924333, alpha: 1)
    
    var stackButtons: UIStackView!
    
    var deleteLayerButton: UIButton!
    var unlockLayerButton: UIButton!
    var unhideLayerButton: UIButton!
    
    var lockLayerButton: UIButton!
    var hideLayerButton: UIButton!
    
    var indexPath: IndexPath!
    
    var delegate: LayerBrowserProtocol?
    
    var isLocked: Bool!
    
    var isViewHidden: Bool!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                highlightCell()
            } else {
                unhighlightCell()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        
        self.backgroundColor = unhighlightColor
        
        deleteLayerButton = UIButton(type: .custom)
        unlockLayerButton = UIButton(type: .custom)
        unhideLayerButton = UIButton(type: .custom)
        
        lockLayerButton = UIButton(type: .custom)
        hideLayerButton = UIButton(type: .custom)
        
        deleteLayerButton.addTarget(self, action: #selector(self.handleDelete(_:)), for: .touchUpInside)
        
        let viewLockUnlock = UIView()
        viewLockUnlock.addSubview(unlockLayerButton)
        unlockLayerButton.translatesAutoresizingMaskIntoConstraints = false
        TMUtils.constraintEdges(of: unlockLayerButton, to: viewLockUnlock)
        viewLockUnlock.addSubview(lockLayerButton)
        lockLayerButton.translatesAutoresizingMaskIntoConstraints = false
        TMUtils.constraintEdges(of: lockLayerButton, to: viewLockUnlock)
        
        let viewUnhideHide = UIView()
        viewUnhideHide.addSubview(hideLayerButton)
        hideLayerButton.translatesAutoresizingMaskIntoConstraints = false
        TMUtils.constraintEdges(of: hideLayerButton, to: viewUnhideHide)
        
        viewUnhideHide.addSubview(unhideLayerButton)
        unhideLayerButton.translatesAutoresizingMaskIntoConstraints = false
        TMUtils.constraintEdges(of: unhideLayerButton, to: viewUnhideHide)
        
        
        unlockLayerButton.addTarget(self, action: #selector(self.handleLock(_:)), for: .touchUpInside)
        unhideLayerButton.addTarget(self, action: #selector(self.handleHide(_:)), for: .touchUpInside)
        
        
        lockLayerButton.addTarget(self, action: #selector(self.handleLock(_:)), for: .touchUpInside)
        hideLayerButton.addTarget(self, action: #selector(self.handleHide(_:)), for: .touchUpInside)
        
        stackButtons = UIStackView(arrangedSubviews: [deleteLayerButton,viewLockUnlock,viewUnhideHide])
        stackButtons.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackButtons)
        stackButtons.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        stackButtons.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8).isActive = true
        stackButtons.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        stackButtons.axis = .horizontal
        stackButtons.distribution = .fillEqually
        stackButtons.alignment = .center
        stackButtons.spacing = 10
        
        layerTitle = UILabel()
        self.contentView.addSubview(layerTitle)
        layerTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layerTitle.translatesAutoresizingMaskIntoConstraints = false
        layerTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        layerTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        layerTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        layerTitle.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        imageOfCanvas = UIImageView()
        self.contentView.addSubview(imageOfCanvas)
        imageOfCanvas.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageOfCanvas.translatesAutoresizingMaskIntoConstraints = false
        imageOfCanvas.topAnchor.constraint(equalTo: self.layerTitle.bottomAnchor, constant: 8).isActive = true
        imageOfCanvas.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageOfCanvas.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageOfCanvas.bottomAnchor.constraint(equalTo: self.stackButtons.topAnchor, constant: -8).isActive = true
        imageOfCanvas.contentMode = .scaleAspectFit
        
        

    }
    
    @objc func handleDelete(_ button: UIButton) {
        print("Handle Delete")
        delegate?.layerClickedDelete(at: indexPath)
    }
    
    @objc func handleHide(_ button: UIButton) {
        print("Handle Hide")
        self.isViewHidden = !self.isViewHidden
        checkHidden(hidden: self.isViewHidden)
        delegate?.layerClickedHide(at: indexPath)
    }
    
    @objc func handleLock(_ button: UIButton) {
        print("Handle Lock")
        self.isLocked = !self.isLocked
        checkLock(lock: self.isLocked)
        delegate?.layerClickedLock(at: indexPath)
    }
    
    
    
    func setDisplayData(title: String, view: UIView, indexPath: IndexPath, delegate: LayerBrowserProtocol, isLocked: Bool, isHidden: Bool) {
        layerTitle.text = title
        self.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.2745098039, blue: 0.2823529412, alpha: 1)
        DispatchQueue.main.async { [weak self] in
            if isHidden {
                view.isHidden = false
                self?.imageOfCanvas.image = UIImage(view: view)
                view.isHidden = true
            } else {
                self?.imageOfCanvas.image = UIImage(view: view)
            }
            
        }
        setNeedsDisplay()
        self.indexPath = indexPath
        self.delegate = delegate
        self.isLocked = isLocked
        self.isViewHidden = isHidden
        checkLock(lock: self.isLocked)
        checkHidden(hidden: self.isViewHidden)
        

    }
    
    func checkHidden(hidden: Bool) {
        if (hidden) {
            hideLayerButton.isHidden = false
            unhideLayerButton.isHidden = true
        } else {
            hideLayerButton.isHidden = true
            unhideLayerButton.isHidden = false
        }
    }
    
    func checkLock(lock: Bool) {
        if (lock) {
            lockLayerButton.isHidden = false
            unlockLayerButton.isHidden = true
        } else {
            lockLayerButton.isHidden = true
            unlockLayerButton.isHidden = false
        }
    }
    
    func highlightCell() {
        self.backgroundColor = highlightColor
    }
    
    func unhighlightCell() {
        self.backgroundColor = unhighlightColor
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deleteLayerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        deleteLayerButton.setImage(UIImage(named: "rubbish-bin"), for: .normal)
        deleteLayerButton.imageView?.contentMode = .scaleAspectFit
        deleteLayerButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 2)
        deleteLayerButton.layer.cornerRadius = 0.5 * deleteLayerButton.bounds.size.height
        deleteLayerButton.clipsToBounds = true
        
        
        unlockLayerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        unlockLayerButton.setImage(UIImage(named: "unlocked"), for: .normal)
        unlockLayerButton.imageView?.contentMode = .scaleAspectFit
        unlockLayerButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 2)
        unlockLayerButton.layer.cornerRadius = 0.5 * unlockLayerButton.bounds.size.height
        unlockLayerButton.clipsToBounds = true
        
        
        lockLayerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        lockLayerButton.setImage(UIImage(named: "locked"), for: .normal)
        lockLayerButton.imageView?.contentMode = .scaleAspectFit
        lockLayerButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 2)
        lockLayerButton.layer.cornerRadius = 0.5 * lockLayerButton.bounds.size.height
        lockLayerButton.clipsToBounds = true
        
        
        unhideLayerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        unhideLayerButton.setImage(UIImage(named: "eye-view"), for: .normal)
        unhideLayerButton.imageView?.contentMode = .scaleAspectFit
        unhideLayerButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        unhideLayerButton.layer.cornerRadius = 0.5 * unhideLayerButton.bounds.size.height
        unhideLayerButton.clipsToBounds = true
        
        hideLayerButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        hideLayerButton.setImage(UIImage(named: "eye-hide"), for: .normal)
        hideLayerButton.imageView?.contentMode = .scaleAspectFit
        hideLayerButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        hideLayerButton.layer.cornerRadius = 0.5 * hideLayerButton.bounds.size.height
        hideLayerButton.clipsToBounds = true
        
        
    }
    
}
