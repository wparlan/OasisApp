//
//  NotificationSettingsViewController.swift
//  Oasis
//
//  Created by Parlan, William C on 12/1/20.
//

import UIKit

class NotificationSettingsViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Local Variables
    let notificationHandler: NotificationHandler = NotificationHandler()
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlets
    // Switch outlets
    @IBOutlet weak var disableAllSwitch: UISwitch!
    @IBOutlet weak var intervalSwitch: UISwitch!
    @IBOutlet weak var morningAlarm: UISwitch!
    @IBOutlet weak var afternoonAlarm: UISwitch!
    @IBOutlet weak var eveningAlarm: UISwitch!
    @IBOutlet weak var nightAlarm: UISwitch!
    // text field outlets
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    // date picker outlets
    @IBOutlet weak var morningDatePicker: UIDatePicker!
    @IBOutlet weak var afternoonDatePicker: UIDatePicker!
    @IBOutlet weak var eveningDatePicker: UIDatePicker!
    @IBOutlet weak var nightDatePicker: UIDatePicker!
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // switch status
        disableAllSwitch.isOn = UserDefaults.standard.bool(forKey: "disableAll")
        intervalSwitch.isOn = UserDefaults.standard.bool(forKey: "interval")
        morningAlarm.isOn = UserDefaults.standard.bool(forKey: "morningAlarm")
        afternoonAlarm.isOn = UserDefaults.standard.bool(forKey: "afternoonAlarm")
        eveningAlarm.isOn = UserDefaults.standard.bool(forKey: "eveningAlarm")
        nightAlarm.isOn = UserDefaults.standard.bool(forKey: "nightAlarm")
        // disable corresponding views
        if !(disableAllSwitch.isOn){
            disableAll()
        }
        else{
            intervalToggled(intervalSwitch)
            morningToggled(morningAlarm)
            afternoonToggled(afternoonAlarm)
            eveningToggled(eveningAlarm)
            nightToggled(nightAlarm)
        }
        
        // text field status
        hourTextField.text = UserDefaults.standard.string(forKey: "hour")
        minuteTextField.text = UserDefaults.standard.string(forKey: "minute")
        // date picker status
        guard let morningDate = UserDefaults.standard.object(forKey: "morningDate") as? Date, let afternoonDate = UserDefaults.standard.object(forKey: "afternoonDate") as? Date, let eveningDate = UserDefaults.standard.object(forKey: "eveningDate") as? Date, let nightDate = UserDefaults.standard.object(forKey: "nightDate") as? Date else{
            return
        }
        morningDatePicker.setDate(morningDate, animated: true)
        afternoonDatePicker.setDate(afternoonDate, animated: true)
        eveningDatePicker.setDate(eveningDate, animated: true)
        nightDatePicker.setDate(nightDate, animated: true)
    }
    
    //MARK: - Segue Functions
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SaveNotificationsSegue"{
            if intervalSwitch.isOn{
                if let hourText = hourTextField.text, let minuteText = minuteTextField.text{
                    // below code is designed to default values to 0 if text field is empty
                    hourTextField.text = hourText == "" ? "0": hourText
                    minuteTextField.text = minuteText == "" ? "0": minuteText
                    guard let hourText = hourTextField.text, let minuteText = minuteTextField.text, let hour = Int(hourText), let minute = Int(minuteText) else{
                            alert(title: "Issue Retrieving Data From Textfields", message: "Something went wrong trying to read the information in the textfields. Try entering the data again.")
                        return false
                    }
                    let interval = hour*3600 + minute*60
                    if interval < 120 {
                        alert(title: "Timed Interval Too Short", message: "The timed interval you set has is too short. Please create a time interval that is at least 2 minutes.")
                        return false
                    }
                }
            }
            
            return true
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            saveUI()
            if identifier == "SaveNotificationsSegue"{
                notificationHandler.clearNotifications()
                if !(disableAllSwitch.isOn) {
                    return
                }
                if intervalSwitch.isOn{
                    let interval = Int(hourTextField.text!)!*3600 + Int(minuteTextField.text!)!*60
                    notificationHandler.setReminder(title: "Timed Reminder", body: "Hey it's been a while, why don't you break for a glass of water.", timeInterval: interval)
                }
                if morningAlarm.isOn{
                    let morningDate = morningDatePicker.date
                    print("morning date in prepare for \(morningDate)")
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: morningDate)
                    let minute = calendar.component(.minute, from: morningDate)
                    
                    notificationHandler.setReminder(identifier: "Morning Alarm",title: "Good Morning!" , body: "Skip the coffee--instead, start the day off right with a tall glass of water!", hour: hour, minute: minute)
                }
                if afternoonAlarm.isOn{
                    let afternoonDate = afternoonDatePicker.date
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: afternoonDate)
                    let minute = calendar.component(.minute, from: afternoonDate)
                    
                    notificationHandler.setReminder(identifier: "Afternoon Alarm", title: "Good Afternoon!", body: "Don't forget to stay hydrated!", hour: hour, minute: minute)
                }
                if eveningAlarm.isOn{
                    let eveningDate = eveningDatePicker.date
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: eveningDate)
                    let minute = calendar.component(.minute, from: eveningDate)
                    
                    notificationHandler.setReminder(identifier: "Evening Alarm", title: "Good Evening!", body: "The day is almost over. Keep up the good work!", hour: hour, minute: minute)
                }
                if nightAlarm.isOn{
                    let nightDate = nightDatePicker.date
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: nightDate)
                    let minute = calendar.component(.minute, from: nightDate)
                    
                    notificationHandler.setReminder(identifier: "Night Alarm", title: "Good night!", body: "Don't forget to go to sleep with a glass of water by your bed in case you get thirsty in the night", hour: hour, minute: minute)
                }
            }
        }
    }
    
    // MARK: - Switch Actions
    @IBAction func disableAllToggled(_ sender: UISwitch) {
        if sender.isOn{
            enableAll()
        }
        else{
            disableAll()
        }
    }
    
    @IBAction func intervalToggled(_ sender: UISwitch) {
        if (sender.isOn){
            disableAllSwitch.setOn(true, animated: true)
            hourTextField.isEnabled = true
            minuteTextField.isEnabled = true
        }
        else{
            hourTextField.isEnabled = false
            minuteTextField.isEnabled = false
        }
    }
    
    @IBAction func morningToggled(_ sender: UISwitch) {
        if (sender.isOn){
            disableAllSwitch.setOn(true, animated: true)
            morningDatePicker.isEnabled = true
        }
        else{
            morningDatePicker.isEnabled = false
        }
    }
    
    @IBAction func afternoonToggled(_ sender: UISwitch) {
        if (sender.isOn){
            disableAllSwitch.setOn(true, animated: true)
            afternoonDatePicker.isEnabled = true
        }
        else{
            afternoonDatePicker.isEnabled = false
        }
    }
    
    @IBAction func eveningToggled(_ sender: UISwitch) {
        if (sender.isOn){
            disableAllSwitch.setOn(true, animated: true)
            eveningDatePicker.isEnabled = true
        }
        else{
            eveningDatePicker.isEnabled = false
        }
    }
    
    @IBAction func nightToggled(_ sender: UISwitch) {
        if (sender.isOn){
            disableAllSwitch.setOn(true, animated: true)
            nightDatePicker.isEnabled = true
        }
        else{
            nightDatePicker.isEnabled = false
        }
    }
    
    //MARK: - Tap Gesture
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer){
        hourTextField.resignFirstResponder()
        minuteTextField.resignFirstResponder()
        morningDatePicker.resignFirstResponder()
        afternoonDatePicker.resignFirstResponder()
        eveningDatePicker.resignFirstResponder()
        nightDatePicker.resignFirstResponder()
        
    }
    
    // MARK: - Helper Functions
    func disableAll(){
        // switches
        intervalSwitch.setOn(false, animated: true)
        morningAlarm.setOn(false, animated: true)
        afternoonAlarm.setOn(false, animated: true)
        eveningAlarm.setOn(false, animated: true)
        nightAlarm.setOn(false, animated: true)
        
        // disable text fields
        hourTextField.isEnabled = false
        minuteTextField.isEnabled = false
        
        // disable date pickers
        morningDatePicker.isEnabled = false
        afternoonDatePicker.isEnabled = false
        eveningDatePicker.isEnabled = false
        nightDatePicker.isEnabled = false
    }
    func enableAll(){
        // switches
        intervalSwitch.setOn(true, animated: true)
        morningAlarm.setOn(true, animated: true)
        afternoonAlarm.setOn(true, animated: true)
        eveningAlarm.setOn(true, animated: true)
        nightAlarm.setOn(true, animated: true)
        
        // enable text fields
        hourTextField.isEnabled = true
        minuteTextField.isEnabled = true
        
        // enable date pickers
        morningDatePicker.isEnabled = true
        afternoonDatePicker.isEnabled = true
        eveningDatePicker.isEnabled = true
        nightDatePicker.isEnabled = true
    }
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func saveUI(){
        // switch states
        UserDefaults.standard.setValue(disableAllSwitch.isOn, forKey: "disableAll")
        UserDefaults.standard.setValue(intervalSwitch.isOn, forKey: "interval")
        UserDefaults.standard.setValue(morningAlarm.isOn, forKey: "morningAlarm")
        UserDefaults.standard.setValue(afternoonAlarm.isOn, forKey: "afternoonAlarm")
        UserDefaults.standard.setValue(eveningAlarm.isOn, forKey: "eveningAlarm")
        UserDefaults.standard.setValue(nightAlarm.isOn, forKey: "nightAlarm")
       
        // text field states
        UserDefaults.standard.setValue(hourTextField.text, forKey: "hour")
        UserDefaults.standard.setValue(minuteTextField.text, forKey: "minute")
       
        // Date picker states
        UserDefaults.standard.setValue(morningDatePicker.date, forKey: "morningDate")
        UserDefaults.standard.setValue(morningDatePicker.date, forKey: "morningDate")
        UserDefaults.standard.setValue(afternoonDatePicker.date, forKey: "afternoonDate")
        UserDefaults.standard.setValue(eveningDatePicker.date, forKey: "eveningDate")
        UserDefaults.standard.setValue(nightDatePicker.date, forKey: "nightDate")
    }
}
    

