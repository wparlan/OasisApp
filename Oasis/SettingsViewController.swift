//
//  SettingsViewController.swift
//  Oasis
//  View Controller for the Settings tab of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: None
//
//  Created by Greeley Lindberg and William Parlan on 12/13/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    /**
     Allows all the settings view controllers (Notifications, Info) to return to the main settings page.
     - Parameter segue: The segue that returned to this View Controller
     - Returns: Void
     */
    @IBAction func unwindToSettingsViewController(segue: UIStoryboardSegue){
        if let identifier = segue.identifier {
            if identifier == "SaveNotificationsSegue" {
                let alertController = UIAlertController(title: "Notifications Saved", message: "Notification Settings Saved Succesfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                print("Settings saved")
            }
        }
    }
    /**
     Toggle Music to the opposite setting.
     - Parameter sender: The toggle music button that sends the signal.
     - Returns: Void
     */
    @IBAction func toggleMusic(_ sender: UIButton) {
        if let tabBarVC = tabBarController as? TabBarViewController{
            tabBarVC.toggleMusic()
        }
        else{
            print("Error toggling music.")
        }
    }
}
