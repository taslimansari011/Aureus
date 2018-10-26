//
//  ViewController.swift
//  ChiropracticeFirst
//
//  Created by Vaibhav Singla on 10/19/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    // MARk: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.appThemeColor
    }
    // 230,25 56
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
//        let appointmentArray = Appointment.getAppointmentArray(dict: Appointment.getAppointmentsDictionary())
//        for appointment in appointmentArray {
//            print(appointment.alertString)
//            print("\n\n")
//        }
        let eventOrganizer = EventOrganizer.init(withDictionary: EventOrganizer.getEventOrganizerArray().first! )
        if let events = eventOrganizer.events {
            for appointment in events {
                print(appointment.alertString)
                print("\n\n")
            }
        }
        let parentViewController = ParentViewController.instanceFromStoryboard(storyBoardName: Storyboard.main.rawValue, type: ParentViewController.self)
        self.navigationController?.pushViewController(parentViewController, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! ParentViewController
//        let appointmentArray = Appointment.getAppointmentArray(dict: Appointment.getAppointmentsDictionary())
//        for appointment in appointmentArray {
//            print(appointment.alertString)
//            print("\n\n")
//        }
//        controller.appArray = appointmentArray
//    }
    
}

