import UIKit
import SnapKit
import WebKit
import Lottie
import AMPopTip
import SafariServices

enum EyeState {
    case close
    case open
    
    mutating func toggle() {
        self = (self == .close) ? .open : .close
    }
}

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    // Variables
    var annotationCounter = 1
    var products: [ImageAnnotation] = []
    var currentEyeState: EyeState = .open
    
    var post: UploadedPost? {
        didSet {
            setupUI()
        }
    }
    
    // UI Components
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "camera")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let closePostVCButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        // İkonunuzu UIImage ile yükleyin.
        if let iconImage = UIImage(named: "close-filled") {
            // İkonunuzu mavi renge boyayın ve butona atayın.
            let tintedIcon = iconImage.withRenderingMode(.alwaysTemplate)
            btn.setImage(tintedIcon, for: .normal)
        }
        btn.tintColor = .black
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    let userProfileImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "emptyUser")
        imageview.layer.cornerRadius = 20
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    let userInfoView: UIView = {
        let view = UIView()
        //        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        //        view.layer.borderWidth = 1
        //        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryBlurView: UIView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = .init(hexString: "bb4a02")
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.layer.cornerRadius = 2 // Dilediğiniz bir cornerRadius değeri verebilirsiniz
        visualEffectView.clipsToBounds = true
        return visualEffectView
    }()
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.textColor = .systemGray2
        return label
    }()
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let savePostButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        // İkonunuzu UIImage ile yükleyin.
        if let iconImage = UIImage(systemName: "bookmark") {
            // İkonunuzu mavi renge boyayın ve butona atayın.
            let tintedIcon = iconImage.withRenderingMode(.alwaysTemplate)
            btn.setImage(tintedIcon, for: .normal)
        }
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let eyeState: UIButton = {
        let iv = UIButton()
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .init(hexString: "7c7c7c")
        iv.layer.cornerRadius = 15
        iv.tintColor = .white
        iv.setImage(UIImage(systemName: "eye"), for: .normal)
        let insetAmount: CGFloat = 5 // İç kenar boşluğunu ayarlayın
        iv.contentEdgeInsets = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            // Ekranı aşağı doğru çektiğimizde ViewController'ı kapatıyoruz.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // UI design configure
    private func setupUI() {
        view.backgroundColor = .init(hexString: "#fffffe")
        addViews()
        fetchData()
        makeConstraints()
        addAnnotation()
        addTargets()
    }
    
    func addTargets() {
        closePostVCButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        eyeState.addTarget(self, action: #selector(handleEyeState), for: .touchUpInside)
    }
    
    public func addViews() {
        view.addSubview(userInfoView)
        view.addSubview(closePostVCButton)
        view.addSubview(postImageView)
        view.addSubview(buttonsView)
        view.addSubview(lineView)
        userInfoView.addSubview(postDescriptionLabel)
        userInfoView.addSubview(userProfileImageview)
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(categoryBlurView)
        userInfoView.addSubview(dateLabel)
        categoryBlurView.addSubview(categoryNameLabel)
        buttonsView.addSubview(savePostButton)
        buttonsView.addSubview(userProfileImageview)
        buttonsView.addSubview(userNameLabel)
        postImageView.addSubview(eyeState)
    }
    
    func fetchData() {
        guard let post = post else { return }
        postImageView.sd_setImage(with: URL(string: post.imageURL))
        self.products = post.prodAnnotations
        self.dateLabel.text = post.date.formatted(date: .long, time: .omitted)
        self.userNameLabel.text = post.userEmail.emailUsername()
        self.postDescriptionLabel.text = post.postDescription
        self.categoryNameLabel.text = post.category
    }
    
    @objc func dismissPage() {
        self.dismiss(animated: true)
    }
    
    @objc func handleEyeState() {
        // Enum değerini tersine çevir
        currentEyeState.toggle()
        
        for subview in postImageView.subviews {
            if let annotationLottieView = subview as? LottieAnimationView {
                annotationLottieView.isHidden = (currentEyeState == .close)
            }
        }
        
        // Enum değerine göre görüntüyü güncelle
        if currentEyeState == .open {
            eyeState.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            eyeState.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            
        }
    }
    
    func addAnnotation() {
        // Eğer bir sayacı korumak istiyorsak, başka bir değişken tanımlayarak saklayabiliriz.
        var preservedAnnotationID = annotationCounter
        
        for prod in products {
            let location = CGPoint(x: prod.xPosition!, y: prod.yPosition!)
            
            let annotationLottieView = LottieAnimationView(name: "lastAnim")
            animationConfigure(lottie: annotationLottieView, location: location)
            
            // ImageView'a annotation'ı ekleme
            postImageView.addSubview(annotationLottieView)
            
            // preservedAnnotationID değerini kullanarak annotationID'yi belirle
            let annotationID = preservedAnnotationID
            preservedAnnotationID += 1
            
            // Annotation üzerine tıklama tanımlama
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            annotationLottieView.addGestureRecognizer(tapGesture)
            annotationLottieView.isUserInteractionEnabled = true
            // Annotation'ın etiketini ayarlama
            annotationLottieView.tag = annotationID
            
            if currentEyeState == .close {
                annotationLottieView.isHidden = true
            }
        }
    }
    
    private func makeConstraints() {
        
        closePostVCButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(20)
        }
        
        postImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(closePostVCButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(500)
        }
        
        categoryBlurView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(110)
            make.height.greaterThanOrEqualTo(30)
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
        }
        
        categoryNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(postDescriptionLabel.snp.leading)
            make.top.equalTo(postDescriptionLabel.snp.bottom).offset(15)
        }
        
        buttonsView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(postImageView.snp.bottom)
        }
        
        userProfileImageview.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageview.snp.centerY)
            make.leading.equalTo(userProfileImageview.snp.trailing).offset(10)
        }
        
        postDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryBlurView.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        userInfoView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.top.equalTo(buttonsView.snp.bottom).offset(5)
            //            make.bottom.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        savePostButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(30)
        }
        
        eyeState.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(5)
        }
        
    }
    
    // Animation Configure function
    private func animationConfigure(lottie: LottieAnimationView, location: CGPoint) {
        lottie.alpha = 0.8
        lottie.loopMode = .loop
        lottie.frame = CGRect(x: location.x, y: location.y, width: 30, height: 30)
        lottie.contentMode = .scaleAspectFill
        lottie.play()
    }
    
    // Yuvarlak yerine lottie animasyonu kullanıyorum.
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if let annotationView = gestureRecognizer.view as? LottieAnimationView {
            
            let annotationID = annotationView.tag
            print("Tıklanan annotation ID'si: \(annotationID)")
            popTipOpen(annotationView: annotationView, annotationID: annotationID)
        }
    }
    
    func popTipOpen(annotationView: LottieAnimationView, annotationID: Int) {
        let popTip = PopTip()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        containerView.layer.cornerRadius = Constants.cornerRadius
        
        // Label 1
        let label1: UILabel = {
            let label1 = UILabel()
            label1.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label1.text = "\(products[annotationID-1].product?.name ?? "")"
            label1.textAlignment = .left
            label1.textColor = UIColor.white
            label1.translatesAutoresizingMaskIntoConstraints = false
            return label1
        }()
        
        let label2: UILabel = {
            let label2 = UILabel()
            label2.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label2.numberOfLines = 0
            label2.textColor = UIColor.white
            label2.text = "₺\(products[annotationID-1].product?.description ?? "")"
            label2.textAlignment = .left
            label2.translatesAutoresizingMaskIntoConstraints = false
            return label2
        }()
        
        let goToLinkIcon: UIButton = {
            let btn = UIButton()
            btn.clipsToBounds = true
            btn.isUserInteractionEnabled = true
            btn.translatesAutoresizingMaskIntoConstraints = false
            // İkonunuzu UIImage ile yükleyin.
            if let iconImage = UIImage(systemName: "chevron.right") {
                // İkonunuzu mavi renge boyayın ve butona atayın.
                let tintedIcon = iconImage.withRenderingMode(.alwaysTemplate)
                btn.setImage(tintedIcon, for: .normal)
            }
            btn.tintColor = .white
            
            return btn
        }()
        
        // Label'ları container view'a ekle
        containerView.addSubview(label1)
        containerView.addSubview(label2)
        containerView.addSubview(goToLinkIcon)
        // Label'ları container view içinde hizalayın
        
        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(20)
        }
        
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(goToLinkIcon.snp.leading)
            make.top.equalTo(label1.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualToSuperview().inset(5)
        }
        
        goToLinkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(label2.snp.centerY)
        }
        
        // Pop-up ayarlarını yapılandırın
        popTip.shouldDismissOnTapOutside = true
        popTip.bubbleColor = .init(hexString: "7c7c7c")
        popTip.cornerRadius = Constants.cornerRadius
        popTip.actionAnimation = .bounce(2)
        popTip.offset = 10
        
        let annotationID = annotationView.tag
        
        popTip.tapHandler = { popTip in
            
            if let url = URL(string: self.products[annotationID-1].product!.link) {
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
            }
            
        }
        
        popTip.show(customView: containerView, direction: .up, in: view, from: CGRect(x: annotationView.frame.minX, y: annotationView.frame.maxY+60,
                                                                                      width: annotationView.frame.width, height: annotationView.frame.height))
    }
    
}
