//
//  FeedProductView.swift
//  test
//
//  Created by macbook pro on 19.07.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class FeedProductViewCell: UITableViewCell{
    
    var post: UploadedPost? {
        didSet {
            updateUI()
        }
    }
    
    let backView: UIView = {
       let view = UIView()
        view.backgroundColor = .init(hexString: "#FDFDFD")
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 15
       return view
    }()
    
    let postImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "feed")
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 7
        return imageview
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = "Favori kombinim"
        label.textAlignment = .left
        label.textColor = .black
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 1
        label.numberOfLines = 2
        return label
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "omernyr"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.textColor = .black
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    let userProfileImageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "emptyUser")
        imageview.layer.cornerRadius = 20
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    private let sharedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.backgroundColor = .clear
        label.textColor = .init(hexString: "#aaaaaa")
        label.clipsToBounds = true
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomBlurView: UIView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = .clear
        visualEffectView.layer.cornerRadius = 15
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.clipsToBounds = true
        return visualEffectView
    }()
    
    let threeDotsButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        // İkonunuzu UIImage ile yükleyin.
        if let iconImage = UIImage(named: "three-dots") {
            // İkonunuzu mavi renge boyayın ve butona atayın.
            let tintedIcon = iconImage.withRenderingMode(.alwaysTemplate)
            btn.setImage(tintedIcon, for: .normal)
        }
        btn.tintColor = .black
        btn.backgroundColor = .clear
        return btn
    }()
    
    let likeButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
//        btn.layer.borderColor = UIColor.black.cgColor
//        btn.layer.borderWidth = 1
        return btn
    }()
    
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
//        btn.layer.borderColor = UIColor.black.cgColor
//        btn.layer.borderWidth = 1
        return btn
    }()
    
    let categoryView: UIView = {
        let blurEffect = UIView()
        blurEffect.layer.cornerRadius = 3
        blurEffect.backgroundColor = .init(hexString: "#bb4a02")
        return blurEffect
    }()
    
    let categoryNameLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.text = "fgdgdg"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
//    let saveButton: UIButton = {
//        let btn = UIButton()
//        btn.clipsToBounds = true
//        btn.isUserInteractionEnabled = true
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
//        btn.tintColor = .black
//        btn.backgroundColor = .clear
//        return btn
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
//    
    private func updateUI() {
        guard let post = post else { return }
        let postImageUrl = URL(string: post.imageURL)
        sharedDateLabel.text = post.date.formatted(date: .long, time: .omitted)
        categoryNameLabel2.text = "\(post.category)"
        postImageView.sd_setImage(with: postImageUrl)
        
        if post.postDescription.count > 50 {
            
            let index = post.postDescription.index(post.postDescription.startIndex, offsetBy: 47)
            let truncatedText = post.postDescription[post.postDescription.startIndex..<index]
            postDescriptionLabel.text = "\(truncatedText)..."
            
        } else {
            postDescriptionLabel.text = post.postDescription
        }
        
        //        postDescriptionLabel.text = post.postDescription
        userNameLabel.text = post.userEmail.emailUsername()
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(postImageView)
        postImageView.addSubview(bottomBlurView)
//        contentView.addSubview(saveButton)
        contentView.addSubview(sharedDateLabel)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userProfileImageview)
//        contentView.addSubview(threeDotsButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(categoryView)
        contentView.addSubview(shareButton)
        categoryView.addSubview(categoryNameLabel2)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func likeButtonTapped() {
        
        updateLikeStatusInFirebase(post!)
        configureLikeButton()
    }
    
    func configureLikeButton() {
        guard let post = post else { return }
        let imageName = post.isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    func updateLikeStatusInFirebase(_ post: UploadedPost) {
//        guard let postIndex = products?.firstIndex(where: { $0.imageURL == post.imageURL }) else { return }
        
        // Firebase'e güncellemeyi yapın (Örnek kod aşağıda)
        let db = Firestore.firestore()
        let postsRef = db.collection("uploadedPosts")
        let postDocument = postsRef.document(post.imageURL)
        
        postDocument.updateData(["likes": post.likes, "isLiked": post.isLiked]) { error in
            if let error = error {
                print("Beğeni güncelleme hatası: \(error.localizedDescription)")
            } else {
                
            }
        }
    }
    
    private func makeConstraints() {
        
//        saveButton.snp.makeConstraints { make in
//            make.trailing.equalTo(postImageView.snp.trailing).offset(-10)
//            make.top.equalTo(postImageView.snp.top).offset(10)
//            make.width.height.equalTo(30)
//        }
        
        backView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().inset(5)
            make.centerX.centerY.equalToSuperview()
        }
        
        postImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(340)
            make.top.equalTo(postDescriptionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        postDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageview.snp.bottom).offset(10)
            make.leading.equalTo(postImageView.snp.leading)
            make.trailing.equalTo(postImageView.snp.trailing)
//            make.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userProfileImageview.snp.trailing).offset(10)
            make.top.equalTo(userProfileImageview.snp.top)
        }
        
        userProfileImageview.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(postImageView.snp.leading)
        }
        
        sharedDateLabel.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.top.equalTo(userNameLabel.snp.bottom)
//            make.leading.equalTo(userNameLabel.snp.leading)
            make.trailing.equalTo(postImageView.snp.trailing)
            make.centerY.equalTo(userNameLabel.snp.centerY)
            make.height.equalTo(20)
        }
        
        bottomBlurView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(5)
        }
        
//        threeDotsButton.snp.makeConstraints { make in
//            make.trailing.equalTo(postImageView.snp.trailing)
//            make.centerY.equalTo(userNameLabel.snp.centerY)
//            make.width.height.equalTo(20)
//        }
        
        likeButton.snp.makeConstraints { make in
            make.leading.equalTo(postImageView.snp.leading)
            make.top.equalTo(postImageView.snp.bottom).offset(7)
            make.width.height.equalTo(30)
        }
        
        shareButton.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(5)
            make.top.equalTo(postImageView.snp.bottom).offset(5)
            make.width.height.equalTo(30)
        }
        
        categoryView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(110)
            make.height.greaterThanOrEqualTo(30)
            make.centerY.equalTo(shareButton.snp.centerY)
            make.trailing.equalTo(postImageView.snp.trailing)
        }

        categoryNameLabel2.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
}
