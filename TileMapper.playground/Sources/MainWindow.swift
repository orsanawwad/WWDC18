import UIKit

//Playground main window
public class MainWindow: UIView {
    
    var mainView: MainView!
    
    var introductionView: IntroductionView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        //Add animation
        mainView = MainView()
        introductionView = IntroductionView()
        self.addSubview(mainView)
        self.addSubview(introductionView)
        TMUtils.constraintEdges(of: mainView, to: self)
        TMUtils.constraintEdges(of: introductionView, to: self)
    }
    
}


//This view supplies the introduction animation and the slide tutorial
class IntroductionView: UIView {
    
    
    var currentIndex: Int = 0
    
    var giantTitle: UILabel!
    
    var giantStartButton: UIButton!
    
    var closeButton: UIButton!
    
    var nextButton: UIButton!
    var previousButton: UIButton!
    
    var containerSlideShow: UIView!
    var slideShowImageView: UIImageView!
    var labelForSlideShow: UITextView!
    
    var images: [UIImage]!
    var texts: [String]!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        
        setupData()
        
        giantTitle = UILabel()
        
        
        giantTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(giantTitle)
        giantTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        giantTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        giantTitle.font = UIFont.systemFont(ofSize: 64)
        giantTitle.text = "TileMapper"
        giantTitle.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        giantTitle.sizeToFit()
        giantTitle.alpha = 0.0
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        
        setupSlideShowViews()
        
        startAnimation()
        
    }
    
    
    func setupSlideShowViews() {
        closeButton = UIButton()
        nextButton = UIButton()
        previousButton = UIButton()
        containerSlideShow = UIView()
        slideShowImageView = UIImageView()
        labelForSlideShow = UITextView()
        

        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nextButton)
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        nextButton.addTarget(self, action: #selector(self.goNext(_:)), for: .touchUpInside)
        nextButton.alpha = 0
        
        previousButton = UIButton()
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previousButton)
        previousButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        previousButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        previousButton.addTarget(self, action: #selector(self.goPrevious(_:)), for: .touchUpInside)
        previousButton.alpha = 0
        previousButton.isHidden = true
        
        
        closeButton = HighlightableButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        closeButton.addTarget(self, action: #selector(self.removeIntroductionScreen(_:)), for: .touchUpInside)
        closeButton.isSelected = false
        closeButton.alpha = 0
        
        containerSlideShow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerSlideShow)
        containerSlideShow.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerSlideShow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerSlideShow.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.67).isActive = true
        containerSlideShow.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.67).isActive = true
        containerSlideShow.addSubview(slideShowImageView)
        containerSlideShow.addSubview(labelForSlideShow)
        self.containerSlideShow.alpha = 0
        self.containerSlideShow.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        slideShowImageView.translatesAutoresizingMaskIntoConstraints = false
        slideShowImageView.topAnchor.constraint(equalTo: self.containerSlideShow.topAnchor).isActive = true
        slideShowImageView.leftAnchor.constraint(equalTo: self.containerSlideShow.leftAnchor).isActive = true
        slideShowImageView.rightAnchor.constraint(equalTo: self.containerSlideShow.rightAnchor).isActive = true
        slideShowImageView.bottomAnchor.constraint(equalTo: self.labelForSlideShow.topAnchor).isActive = true
        slideShowImageView.contentMode = .scaleAspectFit
        slideShowImageView.alpha = 0
        slideShowImageView.image = images[0]
        
        labelForSlideShow.translatesAutoresizingMaskIntoConstraints = false
        labelForSlideShow.bottomAnchor.constraint(equalTo: self.containerSlideShow.bottomAnchor).isActive = true
        labelForSlideShow.leftAnchor.constraint(equalTo: self.containerSlideShow.leftAnchor).isActive = true
        labelForSlideShow.rightAnchor.constraint(equalTo: self.containerSlideShow.rightAnchor).isActive = true
        labelForSlideShow.heightAnchor.constraint(equalToConstant: 72).isActive = true
        labelForSlideShow.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelForSlideShow.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        labelForSlideShow.alpha = 0
        labelForSlideShow.text = texts[0]
        
        giantStartButton = UIButton()
        giantStartButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(giantStartButton)
        giantStartButton.topAnchor.constraint(equalTo: containerSlideShow.bottomAnchor, constant: 20).isActive = true
        giantStartButton.leftAnchor.constraint(equalTo: containerSlideShow.leftAnchor, constant: 20).isActive = true
        giantStartButton.rightAnchor.constraint(equalTo: containerSlideShow.rightAnchor, constant: -20).isActive = true
        giantStartButton.heightAnchor.constraint(equalToConstant: 62).isActive = true
        giantStartButton.isHidden = true
        giantStartButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        giantStartButton.addTarget(self, action: #selector(self.removeIntroductionScreen(_:)), for: .touchUpInside)
        
        
    }
    
    func setupData() {
        images = [UIImage]()
        texts = [String]()
        
        images = [#imageLiteral(resourceName: "slide1-welcome.png"),#imageLiteral(resourceName: "slide2-layers-and-tilebrowser.png"),#imageLiteral(resourceName: "slide3-mute-currenttile-brush-eraser-pan.png"),#imageLiteral(resourceName: "slide4-thisisyourtilebrowser2.png"),#imageLiteral(resourceName: "slide5-tilefamily.png"),#imageLiteral(resourceName: "slide6-layers.png"),#imageLiteral(resourceName: "slide7-thatsit.png")]
        texts = ["Welcome to TileMapper! A Playground that lets you place tiles on top of tiles to help you create amazing 2D Game world maps!","There are 2 main menus here, a layout browser (left), and a tile browser (right)","Over here on the right you got the brush tool, the eraser, and a move tool which lets you move around freely in your game world!","Inside the tile browser, you can pick from a wide variety of tilesets to help you create your own custom world!","There is also a tile family browser where you can choose from different types of tilesets","And over there on the far left we got the layer browser, inside it you can add, delete, lock, or hide a specific layer, note that you have to select the layer when working on it","Thats pretty much it, now click the X icon to start creating your very own world! Have fun!"]
    }
    
    @objc func goNext(_ sender: UIButton) {
        currentIndex = currentIndex + 1
        if currentIndex == images.count - 1 {
            sender.isHidden = true
            giantStartButton.isHidden = false
            closeButton.isHidden = true
        } else {
            sender.isHidden = false
            giantStartButton.isHidden = true
            closeButton.isHidden = false
        }
        previousButton.isHidden = false
        slideShowImageView.image = images[currentIndex]
        labelForSlideShow.text = texts[currentIndex]
        updateTextFont()
    }
    
    @objc func goPrevious(_ sender: UIButton) {
        currentIndex = currentIndex - 1
        if currentIndex == 0 {
            sender.isHidden = true
        } else {
            sender.isHidden = false
        }
        nextButton.isHidden = false
        giantStartButton.isHidden = true
        closeButton.isHidden = false
        slideShowImageView.image = images[currentIndex]
        labelForSlideShow.text = texts[currentIndex]
        updateTextFont()
    }
    
    func updateTextFont() {
        if (labelForSlideShow.text.isEmpty || labelForSlideShow.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
        
        let textViewSize = labelForSlideShow.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = labelForSlideShow.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        
        var expectFont = labelForSlideShow.font;
        if (expectSize.height > textViewSize.height) {
            while (labelForSlideShow.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = labelForSlideShow.font!.withSize(labelForSlideShow.font!.pointSize - 1)
                labelForSlideShow.font = expectFont
            }
        }
        else {
            while (labelForSlideShow.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = labelForSlideShow.font;
                labelForSlideShow.font = labelForSlideShow.font!.withSize(labelForSlideShow.font!.pointSize + 1)
            }
            labelForSlideShow.font = expectFont;
        }
    }
    
    @objc func removeIntroductionScreen(_ sender: UIButton) {
        let animationBlock: () -> Void = { [weak self] in
            self?.alpha = 0
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.removeFromSuperview()
        }
        
        TMUtils.animateWithMaterial(time: 0.7, delay: 0, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    func startAnimation() {
        TMUtils.playAudioInLoop()
        let animationBlock: () -> Void = { [weak self] in
            self?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.fadeInTitle()
        }
        
        TMUtils.animateWithMaterial(time: 1.5, delay: 1, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    func fadeInTitle() {
        let animationBlock: () -> Void = { [weak self] in
            self?.giantTitle.alpha = 1.0
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.fadeOutTitle()
        }
        
        TMUtils.animateWithMaterial(time: 1.5, delay: 0.9, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    func fadeOutTitle() {
        let animationBlock: () -> Void = { [weak self] in
            self?.giantTitle.alpha = 0.0
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.giantTitle.removeFromSuperview()
            self.animateAlphaColorFadeOut()
        }
        
        TMUtils.animateWithMaterial(time: 1.5, delay: 0.6, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    func animateAlphaColorFadeOut() {
        let animationBlock: () -> Void = { [weak self] in
            self?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.6994863014)
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.animateInTheViewsForTheSlideShow()
        }
        
        TMUtils.animateWithMaterial(time: 0.4, delay: 0.65, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    func animateInTheViewsForTheSlideShow() {
        let animationBlock: () -> Void = { [weak self] in
            self?.closeButton.alpha = 1
            self?.nextButton.alpha = 1
            self?.containerSlideShow.alpha = 1
            self?.labelForSlideShow.alpha = 1
            self?.slideShowImageView.alpha = 1
        }
        
        let completionBlock: ((Bool) -> Void)? = { (flag) in
            self.previousButton.alpha = 1
            self.updateTextFont()
        }
        
        TMUtils.animateWithMaterial(time: 0.6, delay: 0, animationBlock: animationBlock, completionBlock: completionBlock)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nextButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        nextButton.setImage(UIImage(named: "right-chevron"), for: .normal)
        nextButton.imageView?.contentMode = .scaleAspectFit
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 6)
        nextButton.layer.cornerRadius = 0.5 * nextButton.bounds.size.width
        nextButton.clipsToBounds = true
        
        
        previousButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        previousButton.setImage(UIImage(named: "left-chevron"), for: .normal)
        previousButton.imageView?.contentMode = .scaleAspectFit
        previousButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 5, bottom: 6, right: 6)
        previousButton.layer.cornerRadius = 0.5 * previousButton.bounds.size.width
        previousButton.clipsToBounds = true
        
        
        closeButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        closeButton.setImage(UIImage(named: "cancel"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        closeButton.layer.cornerRadius = 0.5 * closeButton.bounds.size.width
        closeButton.clipsToBounds = true
        
        
        giantStartButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        giantStartButton.setTitle("Get started!", for: .normal)
//        giantStartButton.imageView?.contentMode = .scaleAspectFit
//        giantStartButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        giantStartButton.layer.cornerRadius = 10
        giantStartButton.clipsToBounds = true
        
        self.updateTextFont()
        
    }
    
}
