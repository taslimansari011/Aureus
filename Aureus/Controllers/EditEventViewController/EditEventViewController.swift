//
//  EditEventViewController.swift
//  ChiropracticFirstDemo
//
//  Created by Aman gupta on 19/10/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class EditEventViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var selectDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var instrumentLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Variables
    var apointmentModel: Appointment?
    var newEventModel: Event = Event.init()
    var eventModel: Event?
    var doneButton = UIBarButtonItem()
    var eventOrg: EventOrganizer?
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        datePicker.datePickerMode = .dateAndTime
        doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
//        datePicker.minimumDate = Date()
        self.title = "Reschedule"
        
        newEventModel.alertString = (eventModel?.alertString)!
        newEventModel.bgColor = eventModel?.bgColor
        newEventModel.eventIsFree = eventModel?.eventIsFree
        newEventModel.id = eventModel?.id
        newEventModel.resourceId = eventModel?.resourceId
        newEventModel.title = eventModel?.title
        
        eventLabel.text = eventOrg?.title
        artistLabel.text = (eventModel?.title?.isEmpty)! ? "Adrian-Jason" : eventModel?.title
        instrumentLabel.text = eventOrg?.instrument
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 3
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) {
        eventModel?.status = .cancel
//        var str = ""
//        str.append("Artist : \(eventModel?.title ?? "")\n")
//        str.append("\(startTimeTextField.text ?? "Not found") - \(endTimeTextField.text ?? "Not found")\n")
        newEventModel.status = .reschedule
        newEventModel.alertString = getAlertStringFrom(eventModel: newEventModel)
        Event.events?.append(self.newEventModel)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Actions
    @IBAction func dateSelectButtonTap(_ sender: UIButton) {
        let datePicker = RSDatePicker.init(view: self.view, pickerMode: .dateAndTime)
        {[weak self] (response: Any?) in
            guard let date = response as? Date else {
                return
            }
            let newDate = date.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
            self?.dateChanged(newDate)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: newDate)
            self?.selectDateTextField.text = dateString
        }
        
        datePicker.setCurrentDate(date: eventModel?.startDate ?? Date())
        datePicker.setMinimumDate(date: Date())
        datePicker.viewContainer.backgroundColor = UIColor.white
    }
    
    @IBAction func timeSelectButtonTap(_ sender: UIButton) {
        let array = ["2018-10-22T06:30:00", "2018-10-22T08:00:00", "2018-10-22T09:00:00", "2018-10-22T11:30:00"]
        let endArray = ["2018-10-22T07:00:00", "2018-10-22T08:30:00", "2018-10-22T09:30:00", "2018-10-22T12:00:00"]
        var startTempArray = [String]()
        var endTempArray = [String]()

        for (index, item) in array.enumerated() {
            let startTime = item
            let endTime = endArray[index]
            let dateFormatter = DateFormatter()
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let startDate = dateFormatter.date(from: startTime) else {
                return
            }
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: startDate)
            let minutes = calendar.component(.minute, from: startDate)
//            print("\(hour):\(minutes)")
//            startTempArray.append("\(hour):\(minutes)")
            if minutes == 30 {
                startTempArray.append("\(hour):\(minutes)")
            } else {
                startTempArray.append("\(hour):00")
            }
            
            guard let endDate = dateFormatter.date(from: endTime) else {
                return
            }
            let calendar1 = Calendar.current
            let hour1 = calendar1.component(.hour, from: endDate)
            let minutes1 = calendar1.component(.minute, from: endDate)
//            print("\(hour1):\(minutes1)")
            if minutes == 30 {
                endTempArray.append("\(hour1):00")
            } else {
                endTempArray.append("\(hour1):\(minutes1)")
            }
        }
        
        let picker = RSPickerView.init(view: self.view, arrayList: startTempArray, keyValue: nil, handler: { (selectedIndex: NSInteger, response: Any?) in
            
            if let index = startTempArray.index(of: response as? String ?? "") {
                self.timeChanged(startTime: array[index], endTime: endArray[index])
                self.endTimeTextField.text = endTempArray[index]
                self.startTimeTextField.text = response as? String ?? ""
            }
            
//            if let index = startTempArray.firstIndex(where: { (value) -> Bool in
//                return value == (response as? String ?? "")
//            }) {
//                self.timeChanged(startTime: array[index], endTime: endArray[index])
//                self.endTimeTextField.text = endTempArray[index]
//                self.startTimeTextField.text = response as? String ?? ""
//            }
            
        })
        picker.viewContainer.backgroundColor = UIColor.white
    }
    
    @IBAction func endTimeSelectButtonTap(_ sender: UIButton) {
    
    }
    
    func dateChanged(_ sender: Date) {
        let newDate = sender.addingTimeInterval(TimeInterval(NSTimeZone.local.secondsFromGMT()))
        newEventModel.startDate = newDate
        newEventModel.endDate = newDate
//        doneButton.isEnabled = true
    }
    
    func timeChanged(startTime: String, endTime: String) {
        newEventModel.startTime = startTime
        newEventModel.endTime = endTime
        doneButton.isEnabled = true
    }
    
    func getAlertStringFrom(eventModel: Event) -> String {
        var str = "Instrument : Piano"
        str.append("\nTeacher : \(eventModel.title ?? "Daisy Yuan")")
        str.append("\nSchedule : \(startTimeTextField.text ?? "") - \(endTimeTextField.text ?? "")\n")
        return str
    }
}
