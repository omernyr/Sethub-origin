//
//  RegistrationViewController.swift
//  InstagramClone
//
//  Created by macbook pro on 7.03.2023.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = .secondarySystemBackground
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        passwordTextField.delegate = self
        emailField.delegate = self
        view.addSubview(passwordTextField)
        view.addSubview(emailField)
        view.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailField.snp.bottom).offset(20)
        }
 
        registerButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
 
    }
    
    @objc func didTapRegisterButton() {
        passwordTextField.resignFirstResponder()
        emailField.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 4 else { return }
        
        AuthManager.shared.registerNewUser(email: email, password: password) { registered in
//            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    if registered {
                        // loged!
                        print("SİGN UP SUCCESSFULLY")
                        let vc = CustomTabbarController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    } else {
                        // error
                        let alert = UIAlertController(title: "Sign Up Error",
                                                                message: "We were unable to log you in",
                                                                preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss",
                                                      style: .cancel))
                        self.present(alert, animated: true)
                        
                    }
                }
//            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordTextField.becomeFirstResponder()
        } else {
            didTapRegisterButton()
        }
        
        return true
    }
}
