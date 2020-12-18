//
//  DateCell.swift
//  Oasis
//  Provides implmentation of the date cell for CalendarViewController of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: https://github.com/patchthecode/JTAppleCalendar/wiki/Tutorials
//
//  Created by Greeley Lindberg and William Parlan on 12/9/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit

class DateCell: JTAppleCell {
    // MARK: - IBOutlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dotView: UIView!
}
