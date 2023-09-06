//
//  CategorizedPostsViewController.swift
//  Sethub
//
//  Created by macbook pro on 3.08.2023.
//
import UIKit
import SnapKit
import FirebaseAuth
import SDWebImage
import Firebase

class CategorizedPotsViewController: UIViewController {
    
    // VARİABLES
    public var products: [UploadedPost]?
    
    // UI COMPONENTS
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.textColor = .black
        return label
    }()
    let feedPostTableView: UITableView = {
        let tv = UITableView()
        tv.showsVerticalScrollIndicator = false
        tv.register(FeedProductViewCell.self, forCellReuseIdentifier: "cell")
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
   
    private func setupUI() {
        feedPostTableView.dataSource = self
        feedPostTableView.delegate = self
        view.backgroundColor = .init(hexString: "#EDF0F3")
        view.addSubview(feedPostTableView)
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        feedPostTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
}

extension CategorizedPotsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedProductViewCell else {
            return UITableViewCell()
        }
        
        let post = products?[indexPath.row]
        cell.post = post
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = products?[indexPath.row]
        let vc = PostViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.post = post
        self.present(vc, animated: true)
    }
    
}


