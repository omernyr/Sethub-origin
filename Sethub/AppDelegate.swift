//
//  AppDelegate.swift
//  Sethub
//
//  Created by macbook pro on 19.07.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Ana pencereyi oluşturun
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        GADMobileAds.sharedInstance().start(completionHandler: nil )
        let rootViewController = CustomTabbarController()
        window?.rootViewController = rootViewController
//        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        return true
    }
    
}
