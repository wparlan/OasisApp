//
//  OasisViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/14/20.
//

import UIKit
import CoreData

class OasisViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var plants: [Plant] = []
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlants()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadPlants()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
        }
    }
    
    // MARK: - Oasis Helper Functions
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
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
        cell.totalWaterLabel.text = "Total water: \(plant.waterLevel)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3;
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
