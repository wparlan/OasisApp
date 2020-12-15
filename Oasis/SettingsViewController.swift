//
//  SettingsViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/13/20.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
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
}
