//
//  Plant+CoreDataProperites.swift
//  Oasis
//  Provides implementation for the NSManaged Class Plant for core data of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source:
//
//  Created by Greeley Lindberg on 12/2/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var dateCompleted: Date?
    @NSManaged public var dateLastWatered: Date?
    @NSManaged public var datePlanted: Date?
    @NSManaged public var imageName: String?
    @NSManaged public var phase: Int32
    @NSManaged public var phase1WaterNeeded: Int32
    @NSManaged public var phase2WaterNeeded: Int32
    @NSManaged public var phase3WaterNeeded: Int32
    @NSManaged public var plantName: String?
    @NSManaged public var waterLevel: Int32
    @NSManaged public var isCurrent: Bool
    @NSManaged public var totalWater: Int32

}

extension Plant : Identifiable {

}
