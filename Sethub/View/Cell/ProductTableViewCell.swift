//
//  ProductTableViewCell.swift
//  test
//
//  Created by macbook pro on 14.07.2023.
//

import UIKit
import SnapKit

class ProductTableViewCell: UITableViewCell {
    
    let backCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    let productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feed")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        addSubview(backCellView)
        backCellView.addSubview(productDescriptionLabel)
        backCellView.addSubview(productNameLabel)
        backCellView.addSubview(productImageView)
        makeConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeConstraints() {
        
        backCellView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().inset(5)
            make.centerX.centerY.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        productDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(productNameLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(5)
        }
        
    }

}
