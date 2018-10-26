//  Created by Taslim Ansari on 10/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarViewDelegate: class {
    func pushForReshduled()
}

class CalendarViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var calendar: FSCalendar!
    
    // MARK: - Variables
    weak var delegate: CalendarViewDelegate?
    var eventOrganizer: EventOrganizer = EventOrganizer.init(withDictionary: EventOrganizer.getEventOrganizerArray().first!)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.calendar != nil {
            eventOrganizer.events = Event.events
            self.calendar.reloadData()
        }
    }

    // MARK: - Setup View
    
    func getDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: string)
//        print("date: \(date)")
        return date
    }
    
    func getOnlyDateStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
//        print(strDate.components(separatedBy: " ")[0])
        return strDate.components(separatedBy: " ")[0]
    }
}

// MARK: - Helper Methods
extension CalendarViewController {
    
    func cancelEvent(event: Event) {
        event.status = .cancel
        self.calendar.reloadData()
    }
    
    func showEventDetails(msg: String, model: Event) {
        if model.status != .cancel {        
            let alert = UIAlertController.init(title: eventOrganizer.organizerName ?? "", message: "Centre name : " + (eventOrganizer.title ?? "") + "\n" + msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Reschedule", style: .default, handler: { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.pushOnEditEvent(model: model)
                }
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: { (_) in
                self.cancelEvent(event: model)
            }))
            alert.addAction(UIAlertAction.init(title: "Exit", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func pushOnEditEvent(model: Event) {
        let editEventViewController = EditEventViewController.instanceFromStoryboard(storyBoardName: Storyboard.main.rawValue, type: EditEventViewController.self)
        editEventViewController.eventModel = model
        editEventViewController.eventOrg = self.eventOrganizer
        self.navigationController?.pushViewController(editEventViewController, animated: true)
    }
    
}

// MARK: - FSCalendarDataSource and FSCalendarDelegate Methods
extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect.init(origin: calendar.frame.origin, size: calendar.bounds.size)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let newDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
    
        for event in eventOrganizer.events ?? [] {
            calendar.select(event.startDate, scrollToDate: false)
            cell.appearance.titleSelectionColor = UIColor.init(hexString: event.textColor ?? "")
        }

    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let newDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        for event in eventOrganizer.events ?? [] {
            if let appDate = event.startDate {
                let appdateString = getOnlyDateStringFrom(date: appDate)
                let selectedDateString = getOnlyDateStringFrom(date: newDate)
                if appdateString == selectedDateString {
                    self.showEventDetails(msg: event.alertString, model: event)
                    
                }
            }
        }
        return false
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let newDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        for event in eventOrganizer.events ?? [] {
            if let appDate = event.startDate {
                let appdateString = getOnlyDateStringFrom(date: appDate)
                let selectedDateString = getOnlyDateStringFrom(date: newDate)
                if appdateString == selectedDateString && event.bgColor != nil {
                    if event.status == .cancel {
                        return UIColor.rescheduledLightGray
                    } else if event.status == .reschedule {
                        return UIColor.gray
                    } else {
                        return UIColor.init(hexString: event.bgColor!)
                    }
                }
            }
        }
        return nil
    }
}
