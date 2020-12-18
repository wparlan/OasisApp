//
//  NotificationHandler.swift
//  Oasis
//  Helper Class to handle scheduling and deleting notifications for the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications
//
//  Created by Greeley Lindberg and William Parlan on 6/13/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationHandler {
    
    let center = UNUserNotificationCenter.current()
    
    /**
     Requests the user's permission to recieve notifications.
     */
    func requestPermission() {
        // Request notification authorizations at first launch
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notifications granted")
            }
            else {
                print ("Notifications declined")
            }
        }
    }
    
    /**
     Sets a notification reminder for a specific time.
     - parameters:
        - identifier: The identifier of the reminder
        - title: The title of the reminder
        - body: The body of the reminder
        - hour: The hour the reminder is set for
        - minute: The minute the reminder is set for
     */
    func setReminder(identifier: String, title: String, body: String, hour: Int, minute: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [title])
        // Configure notification
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default     // could be fun to have a custom sound later on
        
        // Configure the trigger a certain time
        var dateInfo = DateComponents()
        dateInfo.hour = hour
        dateInfo.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
         
        // Request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) {(error) in
            // check error parameter here
            if error != nil{
                print("Error setting reminder \(String(describing: error))")
            }
            print ("Alarm Notification scheduled")
        }
    }
    
    /**
     Sets an interval notification reminder.
     - parameters:
        - title: The title of the reminder
        - body: The body of the reminder
        - timeInterval: The interval detrmining how often the reminder fires
     */
    func setReminder(title: String, body: String, timeInterval: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [title])
        // Configure notification
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        content.sound = UNNotificationSound.default     // could be fun to have a custom sound later on
        
        // Configure the trigger a certain time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: true)
         
        // Request
        let request = UNNotificationRequest(identifier: "Timed Reminder", content: content, trigger: trigger)
        center.add(request) {(error) in
            // check error parameter here
            if error != nil{
                print("Something went wrong --> \(String(describing: error))")
            }
            print("Timed Notification created.")
        }
    }
    
    /**
     Clears prending notifications.
     */
    func clearNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}
