//
//  AppDelegate.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 27.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .clear
        window?.rootViewController = UserListViewController()
        
        return true
    }
}

