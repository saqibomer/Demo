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
        print(Environment.baseURL.absoluteString)
        return true
    }

    

}

