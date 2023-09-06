//
//  CustomProductAlertView.swift
//  test
//
//  Created by macbook pro on 11.07.2023.
//

import UIKit
import SnapKit
import SwiftEntryKit

class CustomProductAlertView: UIView, UITextFieldDelegate {
    
    var delegate: CustomProductAlertDelegate?
    var textFieldsValidStatus: Bool = false
    
    private let backView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
       return view
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 5.0
        textField.placeholder = "Name"
        return textField
    }()
    
    private let productDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 5.0
        textField.placeholder = "Description"
        return textField
    }()
    
    private let productLinkTextField: UITextField = {
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.backgroundColor = .systemGray5
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
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubview(backView)
        backView.addSubview(productNameTextField)
        backView.addSubview(productDescriptionTextField)
        backView.addSubview(productLinkTextField)
        backView.addSubview(doneButton)
        backView.addSubview(errorInvalidLabel)
        backView.addSubview(closeButton)  // Çöp kutusu simgesini ekliyoruz
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditingz)))
        doneButton.addTarget(self, action: #selector(didTappedDoneButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        productNameTextField.delegate = self
        productDescriptionTextField.delegate = self
        productLinkTextField.delegate = self
        makeConstraints()
    }
    
    @objc func endEditingz() {
        self.endEditing(true)
    }
    
    @objc private func closeButtonTapped() {
        
        removeFromSuperview()
    }
    
    @objc func didTappedDoneButton() {
        if productNameTextField.text == "", productLinkTextField.text == "", productDescriptionTextField.text == "" {
            textFieldsValidStatus = true
            errorInvalidLabel.text = "Name or link cannot be left blank."
        } else {
            if let nameText = productNameTextField.text, let descText = productDescriptionTextField.text, let linkText = productLinkTextField.text {
                delegate?.addProduct(prod: ImageAnnotation(xPosition: nil, yPosition: nil, product: Product(name: nameText, description: descText, link: linkText)))
                errorInvalidLabel.text = ""
                // TODO: Bu view kapansın.
                self.removeFromSuperview()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    private func makeConstraints() {
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(250)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalTo(doneButton.snp.centerY)
        }
        
        backView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().inset(10)
        }
        
        productNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(backView.snp.top).offset(10)
        }
        
        productDescriptionTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(productNameTextField.snp.bottom).offset(10)
        }
        
        productLinkTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(50)
            make.top.equalTo(productDescriptionTextField.snp.bottom).offset(10)
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        errorInvalidLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.top.equalTo(productLinkTextField.snp.bottom).offset(10)
            make.leading.equalTo(closeButton.snp.trailing).offset(10)
        }
        
    }
    
}
