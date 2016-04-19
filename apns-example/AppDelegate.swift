//
//  AppDelegate.swift
//  apns-example
//
//  Created by Jakub Machoń on 18.04.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import UIKit
import syncano_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let notificationNameNewMessage = "notificationNewMessage"
    
    var window: UIWindow?
    var deviceToken: NSData?
    let syncano = Syncano.sharedInstanceWithApiKey("636fe828c7363fc220cb0bbc4945f83dfe832571", instanceName: "purple-flower-8258")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeNotificationServices()
        
        return true
    }

    // MARK: notifications
    func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        self.deviceToken = deviceToken
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("register for remote notifications failed: \(error.description)")
    }
    
    // Called when a notification is received and the app is in the
    // foreground (or if the app was in the background and the user clicks on the notification).
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(AppDelegate.notificationNameNewMessage, object: self, userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.NoData)
    }
}

