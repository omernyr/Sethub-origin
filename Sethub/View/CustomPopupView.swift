//
//  CustomPopupView.swift
//  Sethub
//
//  Created by macbook pro on 4.09.2023.
//

import UIKit
import SnapKit
import SwiftEntryKit

protocol CustomProductAlertDelegate {
    func addProduct(prod: ImageAnnotation)
}

class CustomPopupView: UIView, UITextFieldDelegate {
    
    var delegate: CustomProductAlertDelegate?
    var textFieldsValidStatus: Bool = false
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .light)
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Please enter the details of the product you want to share."
        return label
    }()
    
    // TextFields
    let productNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let productPriceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Price"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let productUrlTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Url"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Done Button
    let doneButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.init(hexString: "#ffcf46"), for: .normal)
        btn.layer.masksToBounds = true
        let colorss = [UIColor.init(hexString: "8e3802"), UIColor.init(hexString: "bb4a02")]
        btn.setGradientBackgroundColors(colorss, direction: .toTop, for: .normal)
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return btn
    }()
    
    private let errorInvalidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.backgroundColor = .clear
        label.textColor = .systemRed
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(infoLabel)
        addSubview(productNameTextField)
        addSubview(productPriceTextField)
        addSubview(productUrlTextField)
        addSubview(doneButton)
        addSubview(errorInvalidLabel)
        makeConstraints()
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func makeConstraints() {
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(380)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        productPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).inset(-10)
            make.height.equalTo(50)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        productUrlTextField.snp.makeConstraints { make in
            make.top.equalTo(productPriceTextField.snp.bottom).inset(-10)
            make.height.equalTo(50)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        errorInvalidLabel.snp.makeConstraints { make in
            make.top.equalTo(productUrlTextField.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc private func doneButtonTapped() {
        // Text field'ların içeriğini alabilirsiniz:
        let text1 = productNameTextField.text ?? ""
        let text2 = productPriceTextField.text ?? ""
        let text3 = productUrlTextField.text ?? ""
        
        if text1 == "", text3 == "", text2 == "" {
            textFieldsValidStatus = true
            errorInvalidLabel.text = "Name or link cannot be left blank."
        } else {
            
            delegate?.addProduct(prod: ImageAnnotation(xPosition: nil, yPosition: nil, product: Product(name: text1, description: text2, link: text3)))
            errorInvalidLabel.text = ""
            // TODO: Bu view kapansın.
            SwiftEntryKit.dismiss()
            
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
