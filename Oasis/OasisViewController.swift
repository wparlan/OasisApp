//
//  OasisViewController.swift
//  Oasis
//  View Controller for the Oasis tab of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Sources: https://theswiftdev.com/ultimate-uicollectionview-guide-with-ios-examples-written-in-swift/
// https://www.journaldev.com/10678/ios-uicollectionview-example-tutorial
//
//  Created by Greeley Lindberg and William Parlan on 12/14/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit
import CoreData

class OasisViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // local variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var plants: [Plant] = []
    
    // outlets
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlants()

        // Do any additional setup after loading the view.
    }
   
    // reloads plants and updates the collection view when the view appears
    override func viewDidAppear(_ animated: Bool) {
        loadPlants()
        collectionView.reloadData()
    }
    
    // used to resize OasisCells dynamically
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width - 5, height: self.collectionView.bounds.height)
        }
    }
    
    // MARK: - Oasis Helper Functions
    
    /**
     Loads plants from CoreData.
     */
    func loadPlants() {
        let request: NSFetchRequest<Plant> = Plant.fetchRequest()
        do {
            plants = try context.fetch(request)
        }
        catch {
            print("Could not load plants \(error)")
        }
    }
    
    // MARK: - Collection View Functions
    
    // returns number of sections in collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // returns number of itemes in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    // updates the cell with its respective Plant data.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "MM/dd/yyyy"
        let index = indexPath.row
        let plant = plants[index]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OasisCell", for: indexPath) as! OasisCell
        
        cell.plantNameLabel.text = plant.plantName
        cell.plantImageView.image = UIImage(named: "\(plant.imageName!)-phase-\(plant.phase)")
        if let unwrappedDatePlanted = plant.datePlanted {
            let formattedDatePlanted = dateFomatter.string(from: unwrappedDatePlanted) 
            cell.datePlantedLabel.text = "Date planted: \(formattedDatePlanted)"
        }
        if let unwrappedDateCompleted = plant.dateCompleted {
            let formattedDateCompleted = dateFomatter.string(from: unwrappedDateCompleted)
            cell.dateFinishedLabel.text = "Date completed: \(formattedDateCompleted)"
        }
        else {
            cell.dateFinishedLabel.text = "Date completed: In progress"
        }
        cell.totalWaterLabel.text = "Total water: \(plant.totalWater) oz"
        
        return cell
    }
    
    // Assigns spacing for rows and columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 5;
    }
    
    // Assigns spacing for items in rows and columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
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
