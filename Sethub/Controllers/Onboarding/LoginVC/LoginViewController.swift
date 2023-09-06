//
//  LoginViewController.swift
//  Sethub
//
//  Created by macbook pro on 19.07.2023.
//

import UIKit
import SafariServices
import SnapKit
import AuthenticationServices
import FirebaseAuth

struct Constants {
    static let cornerRadius: CGFloat = 10.0
}

class LoginViewController: UIViewController {
    
    let imageNames = ["back1", "back2", "back3", "back4"] // Resim dosyalarınızın adları
    var currentIndex = 0 // Şu anki görüntü indeksi
    
    let backImageView: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0.6
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let newUserButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create a new user", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    let signupButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.backgroundColor = .clear
        btn.setTitleColor(.white, for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    let sImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "s")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let sethubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Sethub"
        label.font = UIFont.systemFont(ofSize: 29, weight: .medium)
        return label
    }()
    
    let sethubDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Share your uniqueness of style."
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newUserButton.addTarget(self, action: #selector(openCreateUserVC), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(openSignInVC), for: .touchUpInside)
        addSubviews()
        configureBackImageView()
    }
    
    public func configureBackImageView() {
        backImageView.image = UIImage(named: imageNames[currentIndex])
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateImage), userInfo: nil, repeats: true)
    }
    
    private func addSubviews() {
        view.addSubview(newUserButton)
        view.addSubview(signupButton)
        view.addSubview(sImageView)
        view.addSubview(sethubLabel)
        view.addSubview(sethubDescriptionLabel)
        view.insertSubview(backImageView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser != nil {
                
                let loginVC = FeedViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
                
            } 
        }
    }
    
    @objc func updateImage() {
        // Resimleri sırayla göster
        currentIndex = (currentIndex + 1) % imageNames.count
        backImageView.image = UIImage(named: imageNames[currentIndex])
    }
    
    @objc func openCreateUserVC() {
        let VC = CreateUserViewController()
        VC.modalPresentationStyle = .pageSheet
        VC.sheetPresentationController?.detents = [.medium()]
        VC.sheetPresentationController?.prefersGrabberVisible = false
        present(VC, animated: true)
    }
    
    @objc func openSignInVC() {
        let VC = SignInViewController()
        VC.modalPresentationStyle = .pageSheet
        VC.sheetPresentationController?.detents = [.medium()]
        VC.sheetPresentationController?.prefersGrabberVisible = false
        present(VC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }

        newUserButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.bottom.equalTo(signupButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        sImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(sethubLabel.snp.top).inset(-10)
        }
        
        sethubLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        sethubDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.top.equalTo(sethubLabel.snp.bottom).offset(10)
        }
    }
    
}
