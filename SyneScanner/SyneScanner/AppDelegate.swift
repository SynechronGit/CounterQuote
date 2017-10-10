//
//  AppDelegate.swift
//  SyneScanner
//
//  Created by Kartik on 20/09/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BITHockeyManager.shared().configure(withIdentifier: "f2b9242e747d4354a632f9fc955f97df")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation() // This line is obsolete in the crash only builds

        SVProgressHUD.setRingThickness(2.5)

        SVProgressHUD.setForegroundColor(UIColor(red:73/255, green:135/255, blue:233/255, alpha:1))

        IQKeyboardManager.sharedManager().enable = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Initial setup methods
    
    func setCustomNavigationBar() {
        let navBackImage:UIImage! = UIImage(named: "BackArrow")
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(navBackImage, for: .normal, barMetrics: .default)
        //UINavigationBar.appearance().
        //self.navigationController.navigationBar.titleTextAttributes = titleDict


    }


}

