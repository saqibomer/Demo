//
//  AppDelegate.swift
//  Demo
//
//  Created by TOxIC on 08/04/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initApp()
        return true
    }
    
    
    
}

extension AppDelegate {
    
    func initApp() {
        URLCache.shared = {
                URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        }()
    }
}

