//
//  UploadPostCategoryCell.swift
//  Sethub
//
//  Created by macbook pro on 29.07.2023.
//
import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .init(hexString: "F6B1DC")
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configureCell(categoryWithEmoji: String) {
        label.text = categoryWithEmoji
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = Constants.cornerRadius
        label.textColor = isSelected ? .white : .black
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemIndigo : .init(hexString: "F6B1DC")
            label.textColor = isSelected ? .white : .black
        }
    }
}
