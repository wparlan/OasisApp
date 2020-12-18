//
//  CalendarViewController.swift
//  Oasis
//  View Controller for the Calendar/History tab of the Oasis App.
//  CPSC 315-01 Fall 2020
//  Final Project
//  Source: https://github.com/patchthecode/JTAppleCalendar/wiki/Tutorials
//
//  Created by Greeley Lindberg and William Parlan on 12/9/20.
//  Copyright © 2020 Lindberg Parlan. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    // MARK: - Local Variables
    let defaults = UserDefaults.standard
    var calendarDataSource: [String:Any] = [:]
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }
    
    // MARK: - IBOutlets
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var plantLabel: UILabel!
    @IBOutlet var totalWaterLabel: UILabel!

    // MARK: - View Functions
    
    // Initial set up for the calendar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        calendarView.selectDates([Date()])
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        populateDataSource()
    }
    // When view comes back into focus, reload data
    override func viewDidAppear(_ animated: Bool) {
        populateDataSource()
        calendarView.reloadData()
    }
    
    // MARK: - Collection View Functions
    
    /**
     Configures the cell of the calendar  collection view.
     - parameters:
        - view: The JTAppleCell view
        - cellState: The month the date-cell belongs to.
     */
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
     
   /**
     Handler that makes it so the calendar only shows the cells associated with the current month.
     - parameters:
        - cell: The DateCell of the calendar collection view.
        - cellState: The month the date-cell belongs to.
    */
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
           cell.isHidden = false
        } else {
           cell.isHidden = true
        }
    }
    
    /**
     Handles cell selection.
     - parameters:
        - cell: The selected DateCell of the calendar collection view.
        - cellState: The month the date-cell belongs to.
     */
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius = 13
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        let selectedDate = formatter.string(from: cellState.date)
        if let data = defaults.dictionary(forKey: selectedDate), let plantName = data.first?.key, let total = data.first?.value {
            plantLabel.text = "Plant: \(plantName)"
            totalWaterLabel.text = "Total: \(total) oz"
        }
        else {
            plantLabel.text = "Plant: "
            totalWaterLabel.text = "Total: 0 oz"
        }
        
    }
    
    // cells the delegate that a date-cell with a specified date was selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // Tells the delegate that a date-cell with a specified date was de-selected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    // Tells the delegate that the JTAppleCalendar is about to display a header
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    // Called to retrieve the size to be used for the month headers
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 70)
    }
    
    /**
     Populates the calendar's data source with the plant watering data stored in User Defaults.
     */
    func populateDataSource() {
        calendarDataSource = defaults.dictionaryRepresentation()
        // update the calendar
        calendarView.reloadData()
    }
    
    /**
     Assigns dots indicating data is present on a given DateCell.
     - Parameters:
        - cell: The DateCell of the calendar collection view.
        - cellState: TThe month the date-cell belongs to.
     */
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = formatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
    }
}

// Asks the data source to return the start and end boundary dates as well as the calendar to use.
extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "01-jan-2020")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid)
    }
}

// Tells the delegate that the JTAppleCalendar is about to display a date-cell.
extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        
       return cell
    }
    
    // Configures calendar DateCells
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
}
