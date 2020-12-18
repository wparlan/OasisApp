//
//  ShopItem.swift
//  Oasis
//  Provides implementation for the ShopItem for the ShopViewController of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: None
//
//  Created by Greeley Lindberg and William Parlan on 12/14/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import Foundation

// We don't need plants displayed int the shop to be saved to CoreData.
// Instead, make a ShopItem class that has the base properties of plant entity.
class ShopItem {
    var plantName: String = ""
    var imageName: String = ""
    var phase1WaterNeeded: Int
    var phase2WaterNeeded: Int
    var phase3WaterNeeded: Int
    
    /**
     Initializes ShopItem using properties based from the Plant entity. A ShopItem acts as the basis for a future Plant.
     - parameters:
        - plantName: The name of the plant
        - imageName: The base of the image asset name
        - phase1WaterNeeded: The water level necessary for a plant to grow to phase 1
        - phase2WaterNeeded: The water level necessary for a plant to grow to phase 2
        - phase3WaterNeeded: The water level neccessary for a plant to grow to phase 3
     */
    init (plantName: String, imageName: String, phase1WaterNeeded: Int, phase2WaterNeeded: Int, phase3WaterNeeded: Int) {
        self.plantName = plantName
        self.imageName = imageName
        self.phase1WaterNeeded = phase1WaterNeeded
        self.phase2WaterNeeded = phase2WaterNeeded
        self.phase3WaterNeeded = phase3WaterNeeded
    }
}
