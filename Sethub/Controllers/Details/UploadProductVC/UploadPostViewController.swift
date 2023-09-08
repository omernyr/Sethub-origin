//
//  ViewController.swift
//  test
//
//  Created by macbook pro on 3.07.2023.
//

import UIKit
import SwiftMessages
import SnapKit
import WebKit
import Lottie
import FirebaseStorage
import Firebase
import SwiftEntryKit
import DTGradientButton

class UploadPostViewController: UIViewController, CustomProductAlertDelegate {
    
    // VALUES
    var annotationCounter = 0
    var products: [ImageAnnotation] = []
    let categoriesWithEmojis: [String] = ["🫧 peeling", "👗 fashion", "🖼️ designer", "🏠 decoration", "💻 coder", "🎵 music", "📷 photography", "📚 study", "📖 library", "🛠 maker", "👋🏻 other"]
    var selectedCategoryIndex: Int?
    var dismissPageState: Bool = true
    
    // UI COMPONENTS
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        return collectionView
    }()
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private let sharePostButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.init(hexString: "#ffcf46"), for: .normal)
        button.layer.masksToBounds = true
        let colorss = [UIColor.init(hexString: "8e3802"), UIColor.init(hexString: "bb4a02")]
        button.setGradientBackgroundColors(colorss, direction: .toTop, for: .normal)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    private let postDescriptionTextField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.backgroundColor = .init(hexString: "fcfcfc")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.placeholder = "Enter the post description"
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.rightViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        return field
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let closeKeyboardButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .black
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    let customView: DashedBorderView = {
        let cv = DashedBorderView()
        cv.layer.cornerRadius = 10
        return cv
    }()
    
    let photoLibraryIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo.stack.fill"))
        imageView.tintColor = .black
        return imageView
    }()
    
    let uploadorCameraInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.init(name: "NunitoSans_10pt", size: 17)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.text = "Upload your photo to post your sethub."
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    let closeImageButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        //        btn.isHidden = true
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
    
    let backView: UIView = {
        let view = UIView()
        view.alpha = 0.5
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray4
        return view
    }()
    
    // GESTURES
    private lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    private lazy var uploadImageGesture = UITapGestureRecognizer(target: self, action: #selector(uploadImagePress))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.frame.origin.y = 0
        view.endEditing(true) // Tüm açık klavyeleri ve metin alanlarını kapatır
        
    }
    
    // UI design configure
    private func setupUI() {
        view.backgroundColor = .init(hexString: "#EDF0F3")
        configurationAddViews()
        configureGestures()
        configureAddTargets()
        makeConstraints()
        collectionView.dataSource = self
        collectionView.delegate = self
        postDescriptionTextField.delegate = self
    }
    
    // MARK: Configuration Views, Gestures, Targets
    
    private func configurationAddViews() {
        view.addSubview(collectionView)
        view.addSubview(postImageView)
        view.addSubview(postDescriptionTextField)
        view.addSubview(sharePostButton)
        view.addSubview(characterCountLabel)
        view.addSubview(customView)
        customView.addSubview(uploadorCameraInfoLabel)
        customView.addSubview(photoLibraryIconImageView)
        customView.insertSubview(backView, at: 0)
        postDescriptionTextField.addSubview(closeKeyboardButton)
        postImageView.addSubview(closeImageButton)
    }
    
    private func configureGestures() {
        postImageView.addGestureRecognizer(longPressGesture)
        customView.addGestureRecognizer(uploadImageGesture)
    }
    
    private func configureAddTargets() {
        closeKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        sharePostButton.addTarget(self, action: #selector(didTappedSharePostbutton), for: .touchUpInside)
        closeImageButton.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        postImageView.image = UIImage(named: "")
        postImageView.isHidden = true
        closeKeyboardButton.isHidden = true
        customView.isHidden = false
        postDescriptionTextField.text = ""
        characterCountLabel.text = ""
    }
    
    @objc func dismissPage() {
        products.removeAll()
        postImageView.subviews.filter { $0 != closeImageButton }.forEach { $0.removeFromSuperview() }
        postImageView.isHidden = true
        postImageView.image = UIImage(systemName: "")
        customView.isHidden = false
        self.dismiss(animated: true)
    }
    
    private func makeConstraints() {
        
        postImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(500)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(customView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        postDescriptionTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(postDescriptionTextField.snp.bottom).offset(5)
            make.right.equalTo(postDescriptionTextField)
            make.height.equalTo(20)
        }
        
        sharePostButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.top.equalTo(characterCountLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(90)
        }
        
        customView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        backView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        uploadorCameraInfoLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        photoLibraryIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(uploadorCameraInfoLabel.snp.top).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        closeImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
        }
        
        closeKeyboardButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(3)
            make.width.height.equalTo(26)
        }
        
    }
    
    // MARK: - KEYBOARD ISSUE
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let textFieldFrame = postDescriptionTextField.frame
            let textFieldBottomY = textFieldFrame.origin.y + textFieldFrame.height
            let keyboardTopY = view.frame.height - keyboardFrame.size.height
            
            if textFieldBottomY > keyboardTopY - 90 {
                let offset = textFieldBottomY - (keyboardTopY - 90)
                view.frame.origin.y -= offset
            }
        }
    }
    
    @objc private func textFieldTextChanged(_ notification: Notification) {
        if let textField = notification.object as? UITextField, textField == postDescriptionTextField {
            let characterCount = textField.text?.count ?? 0
            characterCountLabel.text = "\(characterCount) / 100"
            
            if characterCount > 0 {
                closeKeyboardButton.isHidden = false
            } else {
                closeKeyboardButton.isHidden = true
            }
            
            if characterCount > 100 {
                characterCountLabel.textColor = .systemRed
                sharePostButton.alpha = 0.7
                sharePostButton.isEnabled = false
            } else {
                characterCountLabel.textColor = .gray
                sharePostButton.alpha = 1
                sharePostButton.isEnabled = true
            }
            
        }
    }
    
    @objc func dismissKeyboard() {
        //        view.frame.origin.y = 0
        //        postDescriptionTextField.resignFirstResponder()
        closeKeyboardButton.isHidden = true
        postDescriptionTextField.text = ""
        characterCountLabel.textColor = .gray
        characterCountLabel.text = "0 / 100"
    }
    
    @objc func didTappedSharePostbutton() {
        guard let image = postImageView.image,
              let postDescription = postDescriptionTextField.text,
              !postDescription.isEmpty, // Post description boş değilse devam et
              let userEmail = Auth.auth().currentUser?.email,
              let selectedCategoryIndex = selectedCategoryIndex,
              !getAnnotationsFromImageView().isEmpty else {
            // Eğer eksik alan veya ürün eklenmemişse uyarı popup'ı gösterelim.
            showWarningPopup()
            return
        }
        
        // Resmi Firebase Storage'a yükle ve URL al
        uploadImageToFirebaseStorage(image: image) { imageURL in
            if let imageURL = imageURL {
                // Resmi ve yuvarlakları Firestore'a ekle
                let annotations: [ImageAnnotation] = self.getAnnotationsFromImageView()
                self.addUploadedPostToFirestore(imageURL: imageURL, postDescription: postDescription, annotations: annotations, userEmail: userEmail, selectedCategoryIndex: selectedCategoryIndex)
            } else {
                print("Resim yükleme başarısız.")
            }
        }
    }
    
    func addProduct(prod: ImageAnnotation) {
        DispatchQueue.main.async {
            self.products.append(prod)
        }
    }
    
    // MARK: FİRESTORE OPERATİONS
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { print("Resim verisi oluşturulamadı."); completion(nil); return }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Resim yükleme hatası: \(error)")
                completion(nil)
            } else {
                print("Resim başarıyla yüklendi.")
                imageRef.downloadURL { url, error in
                    if let imageURL = url?.absoluteString {
                        completion(imageURL)
                        
                        let vc = CustomTabbarController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        
                    } else {
                        print("Resim URL'si alınamadı.")
                        completion(nil)
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            // İlerleme takibi yapabilirsiniz (isteğe bağlı)
        }
    }
    
    func getAnnotationsFromImageView() -> [ImageAnnotation] {
        var annotations: [ImageAnnotation] = []
        
        for subview in postImageView.subviews {
            if let lottieView = subview as? LottieAnimationView {
                let location = lottieView.frame.origin
                let annotationID = lottieView.tag
                // Ürün bilgilerini buradan alabilir ve annotations dizisine ekleyebilirsiniz.
                let product = products[annotationID].product
                let annotation = ImageAnnotation(xPosition: Double(location.x), yPosition: Double(location.y), product: product)
                annotations.append(annotation)
            }
        }
        print(annotations)
        return annotations
    }
    
    // MARK: FİRESTORE OPERATİONS
    func addUploadedPostToFirestore(imageURL: String, postDescription: String, annotations: [ImageAnnotation], userEmail: String, selectedCategoryIndex: Int) {
        // Firestore'da yeni bir koleksiyon belgesi oluştur
        let date = Date()
        let id = UUID()
        let uuidString = id.uuidString // UUID'yi dizeye dönüştürün

        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        ref = db.collection("uploadedPosts").addDocument(data: [
            "userEmail": userEmail, // Kullanıcının e-posta adresini ekle
            "id": uuidString, // Kullanıcının e-posta adresini ekle
            "date": date,
            "imageURL": imageURL,
            "postDescription": postDescription,
            "category": categoriesWithEmojis[selectedCategoryIndex],
            "likes": 0,
            "isLiked": false,
            "isSaved": false,
            "prodAnnotations": annotations.map { $0.dictionaryRepresentation }
        ]) { err in
            if let err = err {
                print("Firestore'a yüklenirken hata oluştu: \(err)")
            } else {
                print("Firestore'a başarıyla yüklendi. Belge kimliği: \(ref?.documentID ?? "Belge kimliği yok")")
                self.successSharedFuncAnimation()
            }
        }
    }
    
    // ALERT ANİMATİON FUNCS
    func successSharedFuncAnimation() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: "Başarılı",
                              body: "Ürün başarıyla yüklendi.",
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: UIImage(systemName: "checkmark.circle.fill"),
                              buttonTitle: nil,
                              buttonTapHandler: nil)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 2)
        config.presentationStyle = .top
        config.dimMode = .blur(style: .systemThinMaterial, alpha: 0.3, interactive: true)
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
    }
    // Function to show the warning popup
    func showWarningPopup() {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.configureDropShadow()
        view.configureContent(title: "Uyarı",
                              body: "Lütfen tüm bilgileri doldurun ve en az bir ürün ekleyin.",
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: UIImage(systemName: "exclamationmark.circle.fill"),
                              buttonTitle: nil,
                              buttonTapHandler: nil)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 2)
        config.presentationStyle = .top
        config.dimMode = .blur(style: .systemThinMaterial, alpha: 0.3, interactive: true)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    // select from photo library
    @objc func uploadImagePress() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Add animation with long press function
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: postImageView)
            
            let annotationLottieView = LottieAnimationView(name: "lastAnim")
            animationConfigure(lottie: annotationLottieView, location: location)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            annotationLottieView.addGestureRecognizer(panGesture)
            
            // ImageView'a annotation'ı ekleme
            postImageView.addSubview(annotationLottieView)
            
            let annotationID = annotationCounter
            annotationCounter += 1
            
            // Annotation üzerine tıklama tanımlama
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            
            annotationLottieView.addGestureRecognizer(tapGesture)
            annotationLottieView.isUserInteractionEnabled = true
            
            // Annotation'ın etiketini ayarlama
            annotationLottieView.tag = annotationID
        }
    }
    
    // Animation Configure function
    private func animationConfigure(lottie: LottieAnimationView, location: CGPoint) {
        lottie.alpha = 0.8
        lottie.loopMode = .loop
        lottie.frame = CGRect(x: location.x-15, y: location.y-15, width: 30, height: 30)
        lottie.contentMode = .scaleAspectFit
        lottie.play()
    }
    
    // Drag animation function
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var newCenter = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
        
        // Sınırlamaları kontrol etmek için uygun koşulları ekleyin
        let minX: CGFloat = 0
        let maxX: CGFloat = postImageView.bounds.width
        let minY: CGFloat = 0
        let maxY: CGFloat = postImageView.bounds.height
        newCenter.x = max(minX, min(newCenter.x, maxX))
        newCenter.y = max(minY, min(newCenter.y, maxY))
        
        gesture.view?.center = newCenter
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    // Yuvarlak yerine lottie animasyonu kullanıyorum.
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if let annotationView = gestureRecognizer.view as? LottieAnimationView {
            let annotationID = annotationView.tag
            showAnnotationPopup()
            print("Tıklanan annotation ID'si: \(annotationID)")
        }
        
    }
    
    // Yuvarlağa tıkladığımda bir view açılıyor ve bu view da yuvarlağın (product) name ini, description ını ve linkini giriyorum.
    func showAnnotationPopup() {
        //        let view = MessageView.viewFromNib(layout: .messageView)
        
        //        let contentView = CustomProductAlertView()
        //        contentView.delegate = self
        //        var config = SwiftMessages.defaultConfig
        //        config.presentationStyle = .center
        //        config.duration = .forever
        //        config.dimMode = .blur(style: .systemChromeMaterialDark, alpha: 0.7, interactive: true)
        //        SwiftMessages.show(config: config, view: contentView)
        
        let customView = CustomPopupView()
        customView.layer.cornerRadius = Constants.cornerRadius
        customView.delegate = self
        var attributes = EKAttributes()
        attributes.position = .top
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.roundCorners = .all(radius: Constants.cornerRadius)
        attributes.entryBackground = .color(color: .white)
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
}

// Select from photo library
extension UploadPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            postImageView.isHidden = false
            postImageView.frame = CGRect(x: 0, y: 0, width: selectedImage.size.width, height: selectedImage.size.height)
            postImageView.image = selectedImage
            customView.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// TextField delegate
extension UploadPostViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = postDescriptionTextField.text {
            print(text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        closeKeyboardButton.isHidden = true
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == postDescriptionTextField {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == postDescriptionTextField {
            // xTextField'tan çıkıldığında klavye işlemi sonlandırın
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
}

class DashedBorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder()
    }
    
    func addDashedBorder() {
        let dashedBorder = CAShapeLayer()
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.strokeColor = UIColor.black.cgColor
        dashedBorder.lineDashPattern = [9, 9] // Bu sayıları değiştirerek çizginin kesikli özelliklerini ayarlayabilirsiniz.
        dashedBorder.lineWidth = 2.0
        dashedBorder.frame = bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10) // Köşeleri yuvarlamak için cornerRadius kullanıyoruz.
        dashedBorder.path = path.cgPath
        layer.addSublayer(dashedBorder)
    }
}
