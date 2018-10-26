//
//  EventOrganizer.swift
//  ChiropracticeFirst
//
//  Created by Vaibhav Singla on 10/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

enum EventStatus: String{
    case schedule
    case reschedule
    case cancel
}


class EventOrganizer: NSObject {
    
    var id: String?
    var title: String?
    var organizerName: String?
    var instrument: String?
    var events: [Event]?
    static var eventOrg: EventOrganizer?
    
    init(withDictionary dict : [String: Any]) {
        
        self.id = dict[serviceKey_id] as? String
        self.title = dict[serviceKey_title] as? String
        self.organizerName = dict[serviceKey_name] as? String
        self.instrument = dict[serviceKey_instrument] as? String
        if let eventArrayDict = dict[serviceKey_events] as? [[String: Any]] {
            self.events = Event.geEventArray(fromDictionary: eventArrayDict)
        }
    }
    
    static func getEventOrganizerArray() -> [[String: Any]] {
        let url = Bundle.main.url(forResource: "EventsData", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            return json
            
        } catch {
            print(error)
        }
        return [[String: Any]]()
    }
    
}

class Event: NSObject {
    var id: String?
    var title: String?
    var resourceId: String?
    var startDateString: String?
    var endDateString: String?
    var bgColor: String?
    var textColor: String?
    var eventIsFree: Bool?
    var status: EventStatus = .schedule
    var alertString = ""
    var startDate: Date?
    var endDate: Date?
    var startTime: String?
    var endTime: String?
    static var events: [Event]?
    override init() {
        super.init()
    }
    
    init(withDictionary dict : [String: Any]) {
        super.init()
        self.id = dict[serviceKey_id] as? String
        self.title = dict[serviceKey_title] as? String
        self.resourceId = dict[serviceKey_resourceId] as? String
        self.startDateString = dict[serviceKey_start] as? String
        self.endDateString = dict[serviceKey_end] as? String
        self.bgColor = dict[serviceKey_eventBgColor] as? String
        self.textColor = dict[serviceKey_eventTextColor] as? String
        self.eventIsFree = dict[serviceKey_eventIsFree] as? Bool
        
        if let startDateStr = self.startDateString {
            self.startDate = self.getDateFrom(string: startDateStr)
        }
        
        if let endDateStr = self.endDateString {
            self.endDate = self.getDateFrom(string: endDateStr)
        }
        
        if let start = self.startDateString {
            self.startTime = self.getTimeStrFrom(str: start)
        }
        
        if let end = self.endDateString {
            self.endTime = self.getTimeStrFrom(str: end)
        }
        
//        var str = ""
//        str.append("Artist : \(self.title ?? "Not found")\n")
//        str.append("\(self.startTime ?? "Not found") - \(self.endTime ?? "Not found")\n")
        self.alertString = Event.getAlertStringFrom(eventModel: self)
    }
    
    func getTimeStrFrom(str: String) -> String {
        let timeStr = str.components(separatedBy: "T")[1]
        let time = timeStr.components(separatedBy: ":")[0] + ":" + timeStr.components(separatedBy: ":")[1]
        return time
    }
    
    func getDateFrom(string: String) -> Date? {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        let dateFromString = dateFormatter.date(from: string)
        //        //print(dateFormatter.string(from: dateFromString!))
        //        return dateFromString
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: string)
        //        print("date: \(date)")
        return date
    }
    
    func getTimeFrom(string: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print("\(hour):\(minutes)")
        return "\(hour):\(minutes)"
    }
    
    static func geEventArray(fromDictionary dict: [[String: Any]]) -> [Event] {
        var eventArray = [Event]()
        for item in dict {
            let event = Event.init(withDictionary: item)
            eventArray.append(event)
        }
        events = eventArray
        return eventArray
    }
    
    static func getAlertStringFrom(eventModel: Event) -> String {
        var str = "Instrument : Piano"
        str.append("\nTeacher : \(eventModel.title ?? "Not found")")
        str.append("\nSchedule : \(eventModel.startTime ?? "Not found") - \(eventModel.endTime ?? "Not found")\n")
        return str
    }
}

