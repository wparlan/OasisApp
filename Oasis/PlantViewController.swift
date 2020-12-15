//
//  PlantViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/1/20.
//

import UIKit
import CoreData


class PlantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // local variables
    var plant: Plant? = nil
    var isDead: Bool = false
    let dateFormatter = DateFormatter()
    var dailyWater = 0
    var today = ""
    let defaults = UserDefaults.standard
    var hasPlant = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let options = ["Cup (8 oz)", "Small water bottle (16 oz)", "Medium water bottle (22 oz)", "Large water bottle (32 oz)"]

    
    // IBOutlets
    @IBOutlet var waterImage: UIImageView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var plantNameTextField: UITextField!
    @IBOutlet var plantImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadPlant), name: UIApplication.willEnterForegroundNotification, object: nil)

        // Do any additional setup after loading the view.
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        // picker set up
        popupView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // check if first launch
        hasPlant = UserDefaults.standard.bool(forKey: "hasPlant")
        if !hasPlant {
            hasPlant = true
            UserDefaults.standard.setValue(true, forKey: "hasPlant")
            UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: "today")
            today = UserDefaults.standard.string(forKey: "today")!
            initPlant()
            savePlant()
        }
        else {
            loadPlant()
        }
        
        // load user defaults
        today = UserDefaults.standard.string(forKey: "today")!
        dailyWater = UserDefaults.standard.integer(forKey: "dailyWater")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPlant()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        savePlant()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initPlant() {
        plant = Plant(context: context)
        plant!.phase = 0
        plant!.imageName = "heart-plant"
        plant!.phase1WaterNeeded = 8
        plant!.phase2WaterNeeded = 30
        plant!.phase3WaterNeeded = 50
        plant!.datePlanted = Date()
        plant!.isCurrent = true
        if let plantName = plantNameTextField.text {
            plant!.plantName = plantName
        }
    }
    
    @objc func loadPlant() {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrent == true")
        do {
            plant = try context.fetch(request)[0]
            plantNameTextField.text = plant!.plantName
            if let unwrappedDateLastWatered = plant!.dateLastWatered {
                if Date().timeIntervalSince(unwrappedDateLastWatered) > 20 && plant!.phase != 3 && plant!.phase != 0 {
                    isDead = true;
                    plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)-dead")
                    if ((plant!.phase == 1 && plant!.waterLevel > plant!.phase1WaterNeeded) || (plant!.phase == 2 && plant!.waterLevel > plant!.phase2WaterNeeded)) {
                        plant!.waterLevel = plant!.waterLevel - 16
                    }
                    alertDead()
                }
                //172800
                else {
                    plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
                }
            }
            else {
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-0")
            }
        }
        catch {
            print("No plant to load \(error)")
        }
    }
    
    func savePlant() {
        do {
            try context.save()
        }
        catch {
            print("Error saving plant \(error)")
        }
    }
    
    @IBAction func waterButtonPressed(_ sender: UIButton) {
        if plant!.phase == 3 {
            let alertController = UIAlertController(title: "Time for a new plant!", message: "Your plant is fully grown. Go to the shop to buy a new  plant.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                print("User pressed okay")
            }))
            present(alertController, animated: true, completion: { () -> Void in
                print ("Alert presented")
            })
            return
        }
        popupView.isHidden = false
        plant!.dateLastWatered = Date()
        savePlant()
    }
    
    func animateWater() {
        let frame1: UIImage! = UIImage(named: "water-frame-1")
        let frame2: UIImage! = UIImage(named: "water-frame-2")
        let frame3: UIImage! = UIImage(named: "water-frame-3")
        let frames: [UIImage] = [frame1, frame2, frame3]
        let animation: UIImage! = UIImage.animatedImage(with: frames, duration: 1.0)
        waterImage.image = animation
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {(timer) in
            self.waterImage.image = nil
            self.checkGrowth()
        })
    }
    
    func checkGrowth() {
        if isDead {
            plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
            isDead = false
            return      // dead plant should not be able to grow to next phase
        }
        switch plant!.phase {
        case 0:
            if plant!.waterLevel >= plant!.phase1WaterNeeded {
                plant!.phase += 1
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
            }
        case 1:
            if plant!.waterLevel >= plant!.phase2WaterNeeded {
                plant!.phase += 1
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
            }
        case 2:
            if plant!.waterLevel >= plant!.phase3WaterNeeded{
                plant!.phase += 1
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
                plant!.dateCompleted = Date()
                alertFullyGrown()
            }
        default:
            break
        }
    }
    
    // MARK: - Alerts
    
    func alertFullyGrown() {
        let alertController = UIAlertController(title: "Congratulations!", message: "Your plant is fully grown. Go to the shop to buy a new  plant.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print ("Alert presented")
        })
    }
    
    func alertDead() {
        let alertController = UIAlertController(title: "Uh oh!", message: "Your plant is wilting. Give it a drink of water to revive it. It's important to stay hydrated and healthy.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
            print("User pressed okay")
        }))
        present(alertController, animated: true, completion: { () -> Void in
            print ("Alert presented")
        })
    }
    
    
    // MARK: - Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let choiceIndex = pickerView.selectedRow(inComponent: 0) + 1
        plant!.waterLevel += Int32(choiceIndex) * 8
        plant!.totalWater += Int32(choiceIndex) * 8
        // reset dailyWater to be 0 if it is a new day
        if today != dateFormatter.string(from: Date()) {
            UserDefaults.standard.setValue(dateFormatter.string(from: Date()), forKey: "today")
            today = dateFormatter.string(from: Date())
            dailyWater = 0
        }
        dailyWater += choiceIndex * 8
        UserDefaults.standard.setValue(dailyWater, forKey: "dailyWater")
        let data = [plant!.plantName:dailyWater]
        defaults.setValue(data, forKey: today)
        popupView.isHidden = true
        animateWater()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        popupView.isHidden = true
    }
    
    // MARK: - Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        plant!.plantName = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Closes the keyboard and resigns the text field when the background is tapped.
     - parameter sender: The UITapGestureRecognizer that registers the user's tap.
     */
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        plant!.plantName = plantNameTextField.text
        plantNameTextField.resignFirstResponder()
    }
    
    // MARK: - Segue
    @IBAction func unwindToPlant(segue: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
