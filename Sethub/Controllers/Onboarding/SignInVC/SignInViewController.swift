//
//  SignInViewController.swift
//  Sethub
//
//  Created by macbook pro on 26.08.2023.
//

import UIKit
import SnapKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    let appleSignUpButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .systemGray4
        label.backgroundColor = .clear
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    
    let sethubLabel: UILabel = {
        let label = UILabel()
        label.text = "Sethub"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 43, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    let sethubDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Share the uniqueness with the Sethub app! Discover other styles, collect likes and make every moment you share even more special. Take a pleasant journey on the trail of fashion with Sethub!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(appleSignUpButton)
        view.addSubview(orLabel)
        view.addSubview(createAccountButton)
        view.addSubview(sethubLabel)
        view.addSubview(sethubDescriptionLabel)
        appleSignUpButton.cornerRadius = Constants.cornerRadius
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        appleSignUpButton.addTarget(self, action: #selector(didTapSignInWithApple), for: .touchUpInside)
        makeConstraints()
    }
    
    @objc func didTapSignInWithApple() {
        DispatchQueue.main.async {
            self.signIAppleAccount()
            let vc = FeedViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    private func signIAppleAccount() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
     
    @objc private func didTapCreateAccountButton() {
        let vc = LoginUserViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = false
        present(vc, animated: true)
    }
    
    func makeConstraints() {
        
        sethubLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
        
        sethubDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(sethubLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
        
        appleSignUpButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.centerY.equalToSuperview()
        }
        
        orLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(appleSignUpButton.snp.bottom)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalTo(orLabel.snp.bottom)
        }
        
    }
    
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Apple kimlik doğrulama başarılı oldu, Firebase'e yeni bir kullanıcı kaydediyoruz.
            let email = appleIDCredential.email ?? "" // E-posta bilgisi, gerekli ise alınabilir.
            let userID = appleIDCredential.user // Apple kullanıcı kimliği
            
            // Kullanıcının daha önce kayıtlı olup olmadığını kontrol etmek gerekebilir
            // Bu adımı projenize uygun olarak eklemelisiniz
            
            // Firebase'e yeni kullanıcıyı kaydetmek için gerekli kod
            Auth.auth().createUser(withEmail: email, password: userID) { (authResult, error) in
                if let error = error {
                    print("Firebase kullanıcı oluşturma hatası: \(error.localizedDescription)")
                    return
                }
                
                // Kullanıcı başarıyla kaydedildi.
                print("Kullanıcı başarıyla kaydedildi.")
                
            }
        }
    }
}

