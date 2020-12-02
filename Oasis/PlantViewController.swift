//
//  PlantViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/1/20.
//

import UIKit

class PlantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var waterImage: UIImageView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var pickerView: UIPickerView!
    
    let options = ["Cup (8 oz)", "Small water bottle (16 oz)", "Medium water bottle (22 oz)", "Large water bottle (32 oz)"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func waterButtonPressed(_ sender: UIButton) {
        popupView.isHidden = false
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
        let choiceIndex = pickerView.selectedRow(inComponent: 0)
        popupView.isHidden = true
        animateWater()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        popupView.isHidden = true
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
