//
//  LoginUserViewController.swift
//  Sethub
//
//  Created by macbook pro on 26.08.2023.
//

import UIKit
import SafariServices
import SnapKit
import AuthenticationServices
import FirebaseAuth

class LoginUserViewController: UIViewController, UITextFieldDelegate {
    
    private let userNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email..."
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userNameTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameTextField.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        
    }

    @objc private func didTapLoginButton() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        guard let usernameEmail = userNameTextField.text, !usernameEmail.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 4 else { return }

        AuthManager.shared.loginUser(email: usernameEmail,
                                     password: password) { success in

            DispatchQueue.main.async {
                if success {
                    // loged!
                    SignInViewController().dismiss(animated: true)
                    LoginViewController().dismiss(animated: true)
                    LoginUserViewController().dismiss(animated: true)
                    let vc = CustomTabbarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    // error
                    let alert = UIAlertController(title: "Log In Error",
                                                            message: "We were unable to log you in",
                                                            preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel))
                    self.present(alert, animated: true)

                }
            }
        }
    }
}

extension LoginUserViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapLoginButton()
        }
        
        return false
    }
}
