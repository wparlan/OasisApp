//
//  AppDelegate.swift
//  Oasis
//  AppDelegate for the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: 
//
//  Created by Greeley Lindberg and William Parlan on 11/29/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var hasLaunched: Bool = false
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // check if first time lanching
        print("app did launch")
        hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunched")
        if !hasLaunched {
            hasLaunched = true
            UserDefaults.standard.setValue(true, forKey: "hasLaunched")
            // Enable music for first time
            UserDefaults.standard.setValue(true, forKey: "Music")
            // set daily notifications for morning, noon, evening, and night
            let notification = NotificationHandler()
            notification.requestPermission()
            notification.setReminder(identifier: "Default Morning", title: "Good Morning!" , body: "Skip the coffee--instead, start the day off right with a tall glass of water!", hour: 7, minute: 0)
            notification.setReminder(identifier: "Default Afternoon", title: "Good Afternoon!", body: "Don't forget to stay hydrated!", hour: 12, minute: 30)
            notification.setReminder(identifier: "Default Evening", title: "Good Evening!", body: "The day is almost over. Keep up the good work!", hour: 18, minute: 00)
            notification.setReminder(identifier: "Default Night", title: "Good night!", body: "Don't forget to go to sleep with a glass of water by your bed in case you get thirsty in the night", hour: 21, minute: 0)
            notification.setReminder(title: "Timed Reminder", body: "Hey it's been a while, why don't you break for a glass of water?", timeInterval: 120)
            
            // set notification user defaults
            UserDefaults.standard.setValue(true, forKey: "disableAll")
            UserDefaults.standard.setValue(true, forKey: "interval")
            UserDefaults.standard.setValue(true, forKey: "morningAlarm")
            UserDefaults.standard.setValue(true, forKey: "afternoonAlarm")
            UserDefaults.standard.setValue(true, forKey: "eveningAlarm")
            UserDefaults.standard.setValue(true, forKey: "nightAlarm")
            UserDefaults.standard.setValue("4", forKey: "hour")
            UserDefaults.standard.setValue("0", forKey: "minute")
        }
        
        center.removeAllDeliveredNotifications()
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // clear notifications in notiication center
        center.removeAllDeliveredNotifications()
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Oasis")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

