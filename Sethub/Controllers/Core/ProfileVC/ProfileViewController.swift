//
//  ProfileViewController.swift
//  Sethub
//
//  Created by macbook pro on 21.07.2023.
//
import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import DTGradientButton
import StoreKit
import GoogleMobileAds

class ProfileViewController: UIViewController {

    private var interstitial: GADInterstitialAd?
    var bannerView: GADBannerView!

    // Components
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyUser")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray // Placeholder background color
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    let threeDotsButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        // İkonunuzu UIImage ile yükleyin.
        if let iconImage = UIImage(named: "three-dots") {
            // İkonunuzu mavi renge boyayın ve butona atayın.
            let tintedIcon = iconImage.withRenderingMode(.alwaysTemplate)
            btn.setImage(tintedIcon, for: .normal)
        }
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    let rateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        let colorss = [UIColor.systemGray, UIColor.systemGray2]
        button.setGradientBackgroundColors(colorss, direction: .toTop, for: .normal)
        return button
    }()
    
    let rateTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate App" // Text'inizi burada ayarlayabilirsiniz
        label.textColor = UIColor.white // Text rengini ayarlayabilirsiniz
        return label
    }()
    
    let rateIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.up.forward.app")
        iv.tintColor = .white
        return iv
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        let colorss = [UIColor.systemGray, UIColor.systemGray2]
        button.setGradientBackgroundColors(colorss, direction: .toTop, for: .normal)
        return button
    }()
    
    let shareTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Share App" // Text'inizi burada ayarlayabilirsiniz
        label.textColor = UIColor.white // Text rengini ayarlayabilirsiniz
        return label
    }()
    
    let shareIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "arrow.up.forward.app")
        iv.tintColor = .white
        return iv
    }()
   
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        }
        )
        configureBannerAds()
        setupUI()
        setupLogoutButton()
        fetchUserData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileDataUpdated), name: Notification.Name("ProfileDataUpdated"), object: nil)
    }
    
    @objc func handleProfileDataUpdated() {
        // Verileri güncelle
        fetchUserData()
    }
    
    func fetchUserData() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserUID)

        userRef.getDocument { [weak self] (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                print("Kullanıcı verileri alınamadı veya belirtilen kullanıcı bulunamadı.")
                return
            }

            // Firestore'dan alınan verileri çıkarın
            if let data = document.data(),
               let name = data["name"] as? String,
               let surname = data["surname"] as? String,
               let bio = data["bio"] as? String,
               let userProfileImageURL = data["userProfileImageURL"] as? String {
                let user = User(name: name, surname: surname, bio: bio, userProfileImageURL: userProfileImageURL)
                self?.updateUI(with: user)
            }

        }
        
    }

    private func updateUI(with user: User) {
        // User yapısından gelen verileri kullanarak kullanıcı arayüzünü güncelle
        self.usernameLabel.text = user.name
        self.surnameLabel.text = user.surname
        self.userDescriptionLabel.text = user.bio
        self.profileImageView.sd_setImage(with: URL(string: user.userProfileImageURL))
    }
    
    private func configureBannerAds() {
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .init(hexString: "#EDF0F3")
        configureUI()
        addViews()
        threeDotsButton.addTarget(self, action: #selector(openEdit), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(didTappedRateReviewBtn), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(doSomething), for: .touchUpInside)
        makeConstraints()
    }
    
    private func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(userDescriptionLabel)
        view.addSubview(shareButton)
        view.addSubview(logoutButton)
        view.addSubview(threeDotsButton)
        view.addSubview(rateButton)
        rateButton.addSubview(rateTextLabel)
        rateButton.addSubview(rateIconImageView)
        shareButton.addSubview(shareTextLabel)
        shareButton.addSubview(shareIconImageView)
    }
    
    private func makeConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(threeDotsButton.snp.bottom).offset(20)
//            make.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        surnameLabel.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.trailing)
            make.centerY.equalTo(usernameLabel.snp.centerY)
            make.height.equalTo(50)
        }
        
        userDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(userDescriptionLabel.snp.bottom).offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(shareButton.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        threeDotsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(25)
        }
        
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(30)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        rateTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8) // Text sol tarafta
            make.centerY.equalToSuperview() // Text dikey hizalama
        }
        
        rateIconImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8) // İkon sağ tarafta
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        shareTextLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8) // Text sol tarafta
            make.centerY.equalToSuperview() // Text dikey hizalama
        }
        
        shareIconImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8) // İkon sağ tarafta
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    // MARK: - UI Configuration
    
    func configureUI() {
        
    }
    
    // MARK: - Logout Button Setup
    
    private func setupLogoutButton() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {

        AuthManager.shared.logOut { success in
            
            if success {
                print("Çıkış yapıldı") 
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            } else {
                print("Çıkış yaparken bir hata oluştu.gg")
            }
            
        }

    }
    
    @objc private func didTappedRateReviewBtn() {
        
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/?action=write-review")
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        
    }
    
    @objc func openEdit() {
        let vc = ImageEditViewController()
        present(vc, animated: true)
    }
    
    @objc func doSomething() {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
}

extension ProfileViewController: GADBannerViewDelegate {
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }
    
}
