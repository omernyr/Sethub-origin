
import UIKit
import SnapKit

class ProfileInfoItemTableViewCell: UITableViewCell {
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "sşdflmg"
        label.clipsToBounds = true
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyUser")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        addSubview(productNameLabel)
        addSubview(productImageView)
        makeConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeConstraints() {
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
    }

}
