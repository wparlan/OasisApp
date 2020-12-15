//
//  ShopViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/14/20.
//

import UIKit

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // globals
    var forSale: [Plant] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // outlets
    @IBOutlet var shopCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateForSale()
    }
    
    func populateForSale() {
        // initialize heart plant
        let heartplant = Plant(context: context)
        heartplant.plantName = "Heart Plant"
        heartplant.phase = 0
        heartplant.imageName = "heart-plant"
        heartplant.phase1WaterNeeded = 8
        heartplant.phase2WaterNeeded = 30
        heartplant.totalWaterNeeded = 50
        forSale.append(heartplant)
        
        // initialize rose
        let rose = Plant(context: context)
        rose.plantName = "Roses"
        rose.phase = 0
        rose.imageName = "rose"
        rose.phase1WaterNeeded = 24
        rose.phase2WaterNeeded = 48
        rose.totalWaterNeeded = 80
        forSale.append(rose)
        
        // initialize cactus
        let cactus = Plant(context: context)
        cactus.plantName = "Cactus"
        cactus.phase = 0
        cactus.imageName = "cactus"
        cactus.phase1WaterNeeded = 32
        cactus.phase2WaterNeeded = 64
        cactus.totalWaterNeeded = 100
        forSale.append(cactus)
        
        // initialize sunflower
        let sunflower = Plant(context: context)
        sunflower.plantName = "Sunflower"
        sunflower.phase = 0
        sunflower.imageName = "sunflower"
        sunflower.phase1WaterNeeded = 30
        sunflower.phase2WaterNeeded = 60
        sunflower.totalWaterNeeded = 90
        forSale.append(sunflower)
        
        // initialize coming soon
        let comingSoon = Plant(context: context)
        comingSoon.plantName = "Coming Soon"
        forSale.append(comingSoon)
    }
    
    // MARK: - Collection View Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(forSale.count)
        return forSale.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let plant = forSale[index]
        
        let cell = shopCollection.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as! ShopCell
        
        cell.plantNameLabel.text = plant.plantName
        if index < forSale.count - 1 {
            cell.plantImageView.image = UIImage(named: "\(plant.imageName!)-phase-3")
        }
        else {
            cell.plantImageView.image = UIImage(named: "question-mark")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10;
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
