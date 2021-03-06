//
//  AppDelegate.swift
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override class func initialize () {
        RateReminder.sharedInstance.start()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Analytics.sharedInstance.start()
        UINavigationBar.appearance().tintColor = UIColor(red: 0, green: 188.0/255.0, blue: 242.0/255.0, alpha: 1.0)

        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = UINavigationController(rootViewController: SearchViewController())
        window.makeKeyAndVisible()

        Analytics.sharedInstance.track("Application Opened", properties: ["Type": "Launch"])

        self.window = window

        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        Analytics.sharedInstance.track("Application Opened", properties: ["Type": "From Background"])
    }
}
