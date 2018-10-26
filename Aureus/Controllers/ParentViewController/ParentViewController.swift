//
//  ParentViewController.swift
//
//  Created by Taslim Ansari on 10/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
enum TabIndex: Int {
    case firstChildTab = 0
    case secondChildTab = 1
}

class ParentViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: TabySegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Variables
    var appArray: [Appointment] = []
    var currentViewController: UIViewController?
    
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = ProfileViewController.instanceFromStoryboard(storyBoardName: Storyboard.main.rawValue, type: ProfileViewController.self)
        return firstChildTabVC
    }()
    
    lazy var secondChildTabVC: UIViewController? = {
        let secondChildTabVC = CalendarViewController.instanceFromStoryboard(storyBoardName: Storyboard.main.rawValue, type: CalendarViewController.self)
        secondChildTabVC.delegate = self
        return secondChildTabVC
    }()
    
    static var identifier: String {
        return String.init(describing: self)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = ""
        
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        
        self.title = "Aureus"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Helper Function
    func displayCurrentTab(_ tabIndex: Int) {
        if let controller = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)            
            controller.view.frame = self.contentView.bounds
            self.contentView.addSubview(controller.view)
            self.currentViewController = controller
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var controller: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            controller = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            controller = secondChildTabVC
        default:
            return nil
        }
        return controller
    }
    
    // MARK: - Actions
    // Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func pushOnEditEvent() {
        let editEventViewController = EditEventViewController.instanceFromStoryboard(storyBoardName: Storyboard.main.rawValue, type: EditEventViewController.self)
        self.navigationController?.pushViewController(editEventViewController, animated: true)
    }
    
}

// MARK: - CalendarViewDelegate Methods
extension ParentViewController: CalendarViewDelegate {
    func pushForReshduled() {
        self.pushOnEditEvent()
    }
    
}
