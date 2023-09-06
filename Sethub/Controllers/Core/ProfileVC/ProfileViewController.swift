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

class ProfileViewController: UIViewController {
    
    var post: UploadedPost? {
        didSet {
            setupUI()
        }
    }
    
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
        setupUI()
        setupLogoutButton()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .init(hexString: "#EDF0F3")
        configureUI()
        addViews()
        threeDotsButton.addTarget(self, action: #selector(openEdit), for: .touchUpInside)
        rateButton.addTarget(self, action: #selector(didTappedRateReviewBtn), for: .touchUpInside)
        makeConstraints()
    }
    
    private func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
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
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
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
        guard let post = post else { return }
        usernameLabel.text = "\(post.userEmail)"
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
     
}
