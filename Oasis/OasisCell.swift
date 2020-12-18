//
//  OasisCell.swift
//  Oasis
//  Provides implementation for the OasisCell for the OasisViewController of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: None
//
//  Created by Greeley Lindberg and William Parlan on 12/14/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import Foundation
import UIKit

class OasisCell: UICollectionViewCell {
    //MARK: - IBOutlets
    @IBOutlet var plantNameLabel: UILabel!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var datePlantedLabel: UILabel!
    @IBOutlet var dateFinishedLabel: UILabel!
    @IBOutlet var totalWaterLabel: UILabel!
}
