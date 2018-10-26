//
//  Appointment.swift
//  ChiropracticeFirst
//
//  Created by Vaibhav Singla on 10/19/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import Foundation

class Appointment: NSObject {
    var appointmentId : Int?
    var appointmentDate: String?
    var patientData: ProfileData?
    var doctorData: ProfileData?
    var appointmentData: ProfileData?
    var status: String?
    var hc = "12345 (DT)"
    var vb = "35"
    var phone = "81238123"
    var plan = "Subsidy S40"
    var alertString = ""
    var isRescheduled = false
    var textColor: UIColor = .red
    var bgColor: UIColor = .green
    
    override init() {
        super.init()
    }
    
    init(withDictionary dict : [String: Any]) {
        
        self.appointmentId = dict[serviceKey_appointmentId] as? Int
        self.appointmentDate = dict[serviceKey_appointmentDate] as? String
        self.status = dict[serviceKey_Status] as? String
        if let patientDict = dict[serviceKey_Patient__r] as? [String: Any] {
            self.patientData = ProfileData.init(withDictionary: patientDict)
        }
        if let doctorDict = dict[serviceKey_Doctor_Name__r] as? [String: Any] {
            self.doctorData = ProfileData.init(withDictionary: doctorDict)
        }
        if let appointmentDict = dict[serviceKey_Appointment_Type__r] as? [String: Any] {
            self.appointmentData = ProfileData.init(withDictionary: appointmentDict)
        }
        if self.status != "Scheduled" {
            self.isRescheduled = true
        }
        var str = ""
        str.append("Patient Name: \(self.patientData?.title ?? "Not found")\n")
        str.append("HC: \(self.hc) VB: \(self.vb)\n")
        str.append("Phone: \(self.phone)\n")
        str.append("Appt. Type: (\(self.appointmentData?.title ?? "Not found")) Dur: 1\n")
        str.append("Plan: \(self.plan)\n")
        str.append("Next Appt. Date: \(self.appointmentDate ?? "Not found")")
        self.alertString = str
    }
    
    static func getAppointmentsDictionary() -> [String: Any] {
        let url = Bundle.main.url(forResource: "AppointmentData", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
            return json
            
        } catch {
            print(error)
        }
        return [String: Any]()
    }
    
    static func getAppointmentArray(dict: [String: Any]) -> [Appointment] {
        var appointmentArray = [Appointment]()
        guard let appointmentDictArray = dict[serviceKey_appointments] as? [[String: Any]] else {
            return appointmentArray
        }
        
        for item in appointmentDictArray {
            let appointment = Appointment.init(withDictionary: item)
            appointmentArray.append(appointment)
        }
        return appointmentArray
    }
    
}

class ProfileData: NSObject {
    var title: String?
    var id: String?
    
    override init() {
        super.init()
    }
    
    init(withDictionary dict : [String: Any]) {
        self.id = dict[serviceKey_appointmentId] as? String
        self.title = dict[serviceKey_Name] as? String
    }
    
}
