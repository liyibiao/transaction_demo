//
//  AppDelegate.swift
//  TransactionDemo
//
//  Created by 李艺彪 on 2020/10/16.
//  Copyright © 2020 李艺彪. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let home = ProductDetailModuleBuilder.setupModule().0
        let homeNavigationController = UINavigationController(rootViewController: home)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = homeNavigationController
        self.window?.makeKeyAndVisible()
        return true
    }

}

