//
//  CalendarViewController.swift
//  Oasis
//
//  Created by Greeley Lindberg on 12/9/20.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var plantLabel: UILabel!
    @IBOutlet var totalWaterLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var calendarDataSource: [String:Any] = [:]
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }

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
    
    override func viewDidAppear(_ animated: Bool) {
        populateDataSource()
        calendarView.reloadData()
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
        
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
           cell.isHidden = false
        } else {
           cell.isHidden = true
        }
    }
    
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
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 70)
    }
    
    func populateDataSource() {
        calendarDataSource = defaults.dictionaryRepresentation()
        // update the calendar
        calendarView.reloadData()
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let dateString = formatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.dotView.isHidden = true
        } else {
            cell.dotView.isHidden = false
        }
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

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "01-jan-2018")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        
       return cell
    }
        
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
}
