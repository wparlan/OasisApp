//
//  PlantViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/1/20.
//

import UIKit
import CoreData

class PlantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // TODO: water loss
    
    var plant: Plant? = nil
    
    @IBOutlet var waterImage: UIImageView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var plantNameTextField: UITextField!
    @IBOutlet var plantImageView: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let options = ["Cup (8 oz)", "Small water bottle (16 oz)", "Medium water bottle (22 oz)", "Large water bottle (32 oz)"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsDirectoryURL)
        popupView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        initPlant()
        loadPlant()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPlant()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        savePlant()
    }
    
    
    func initPlant() {
        plant = Plant(context: context)
        plant!.phase = 0
        plant!.imageName = "heart-plant"
        plant!.phase1WaterNeeded = 8
        plant!.phase2WaterNeeded = 30
        plant!.totalWaterNeeded = 50
        plant!.datePlanted = Date()
        plant!.isCurrent = true
        if let plantName = plantNameTextField.text {
            plant!.plantName = plantName
        }
    }
    
    func loadPlant() {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrent == true")
        do {
            plant = try context.fetch(request)[0]
            plantNameTextField.text = plant!.plantName
            if let unwrappedDateLastWatered = plant!.dateLastWatered {
                if Date().timeIntervalSince(unwrappedDateLastWatered) > 20 && (plant!.phase == 1 || plant!.phase == 2) {
                    plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)-dead")
                    plant!.waterLevel = plant!.waterLevel - 16
                }
                //172800
            }
            else {
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
            }
        }
        catch {
            print("Error loading plant \(error)")
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
        if plantImageView.image == UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)-dead") {
            plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
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
            if plant!.waterLevel >= plant!.totalWaterNeeded{
                plant!.phase += 1
                plantImageView.image = UIImage(named: "\(plant!.imageName!)-phase-\(plant!.phase)")
                alertFullyGrown()
            }
        default:
            break
        }
    }
    
    func alertFullyGrown() {
        let alertController = UIAlertController(title: "Congratulations!", message: "Your plant is fully grown. Go to the shop to buy a new  plant.", preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
