//
//  AddProductViewController.swift
//  Sethub
//
//  Created by macbook pro on 4.09.2023.
//

import UIKit
import SnapKit
import SwiftEntryKit

protocol CustomProductAlertDelegatex {
    func addProduct(prod: ImageAnnotation)
}

class AddProductViewController: UIViewController {
    
    var delegate: CustomProductAlertDelegatex?
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.0
        textField.placeholder = "Name"
        return textField
    }()
    
    private let productDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.0
        textField.placeholder = "Description"
        return textField
    }()
    
    private let productLinkTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 5.0
        textField.placeholder = "URL"
        return textField
    }()
    
    private let errorInvalidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .light)
        label.backgroundColor = .clear
        label.textColor = .systemRed
        label.text = ""
        return label
    }()
    
    private let addProductButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = (.clear)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .init(hexString: "#EDF0F3")
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(productNameTextField)
        view.addSubview(productDescriptionTextField)
        view.addSubview(productLinkTextField)
        view.addSubview(errorInvalidLabel)
        view.addSubview(addProductButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeConstraints()
    }
    
    private func makeConstraints() {
        addProductButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.trailing.equalTo(view.snp.trailing).inset(5)
        }
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(addProductButton.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        productDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        productLinkTextField.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        errorInvalidLabel.snp.makeConstraints { make in
            make.top.equalTo(productLinkTextField.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func addFunc() {
        print("add")
        
//        delegate?.addProduct(prod: ImageAnnotation(xPosition: nil, yPosition: nil, product: nil))

    }
    
    
}
