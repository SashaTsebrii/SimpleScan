//
//  AppDelegate.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/3/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let listController = ListController()
        let navigationController = UINavigationController(rootViewController: listController)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = UIColor.black.withAlphaComponent(0.8)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        
        window?.tintColor = UIColor.white
                
        return true
    }

}

