//
//  CustomTabbarViewController.swift
//  Sethub
//
//  Created by macbook pro on 21.07.2023.
//

import UIKit
import ESTabBarController
import SnapKit
import Lottie

class CustomTabbarController: ESTabBarController {
    
    let myView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        let logoSize: CGFloat = 40 // Resim boyutunu ayarlayın
        let logo = UIImageView(image: UIImage(named: "AppIcon"))
        logo.frame = CGRect(x: (view.bounds.width - logoSize) / 2, y: (view.bounds.height - logoSize) / 2, width: logoSize, height: logoSize)
        logo.layer.cornerRadius = 5 // Köşe yuvarlama eklemek için yarıçapı resmin yarıçapı ile aynı yapın
        logo.layer.masksToBounds = true // Resmin sınırlarını sınırla
        logo.contentMode = .scaleAspectFit // Resmi görüntüleme modunu ayarlayın
        view.addSubview(logo)
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Özel tab bar'ı oluşturmak için çağrı yapılır.
        setupTabBar()
//        self.navigationItem.titleView = myView
        
    }
    
    func setupTabBar() {
        let feedVC = FeedViewController()
        let searchVC = SearchViewController()
        let notificationsVC = UploadPostViewController()
        let profileVC = ProfileViewController()
        
        let highlightIconColor = UIColor.black
        
        let feedView = ESTabBarItemContentView()
        feedView.highlightIconColor = highlightIconColor
        
        let searchView = ESTabBarItemContentView()
        searchView.highlightIconColor = highlightIconColor
        
        let notificationsView = ESTabBarItemContentView()
        notificationsView.highlightIconColor = highlightIconColor
        
        let profileView = ESTabBarItemContentView()
        profileView.highlightIconColor = highlightIconColor
        
        feedVC.tabBarItem = ESTabBarItem.init(feedView,
                                              title: nil,
                                              image: UIImage(named: "home-outline"),
                                              selectedImage: UIImage(named: "home-solid"))
        searchVC.tabBarItem = ESTabBarItem.init(searchView,
                                                title: nil,
                                                image: UIImage(named: "search-outline"),
                                                selectedImage: UIImage(named: "search-solid"))
        notificationsVC.tabBarItem = ESTabBarItem.init(notificationsView,
                                                       title: nil,
                                                       image: UIImage(named: "ADD"),
                                                       selectedImage: UIImage(named: "add-4"))
        profileVC.tabBarItem = ESTabBarItem.init(profileView,
                                                 title: nil,
                                                 image: UIImage(named: "person-outline"),
                                                 selectedImage: UIImage(systemName: "person.fill"))
        
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.systemGray2.cgColor
        self.tabBar.backgroundColor = .init(hexString: "fffffe")
        
        self.viewControllers = [feedVC, searchVC, notificationsVC, profileVC]
    }
    
}
