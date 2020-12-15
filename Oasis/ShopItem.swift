//
//  ShopItem.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/14/20.
//

import Foundation

// We don't need plants displayed int the shop to be saved to CoreData.
// Instead, make a ShopItem class that has the base properties of plant entity.
class ShopItem {
    var plantName: String = ""
    var imageName: String = ""
    var phase1WaterNeeded: Int
    var phase2WaterNeeded: Int
    var totalWaterNeeded: Int
    
    init (plantName: String, imageName: String, phase1WaterNeeded: Int, phase2WaterNeeded: Int, totalWaterNeeded: Int) {
        self.plantName = plantName
        self.imageName = imageName
        self.phase1WaterNeeded = phase1WaterNeeded
        self.phase2WaterNeeded = phase2WaterNeeded
        self.totalWaterNeeded = totalWaterNeeded
    }
}
