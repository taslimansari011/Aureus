//
//  TabySegmentedControl.swift
//
//  Created by Taslim Ansari on 10/20/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TabySegmentedControl: UISegmentedControl {

    func initUI() {
        setupBackground()
        setupFonts()
    }
    
    func setupBackground() {
        let backgroundImage = UIImage(named: "segmented_unselected_bg")
        let dividerImage = UIImage(named: "segmented_separator_bg")
        let backgroundImageSelected = UIImage(named: "segmented_selected_bg")
        
        self.setBackgroundImage(backgroundImage, for: UIControlState(), barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .selected, barMetrics: .default)
        
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: UIControlState(), barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: .default)
    }
    
    func setupFonts() {
        let font = UIFont.systemFont(ofSize: 16.0)
        
        let normalTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: font
        ]
        
        self.setTitleTextAttributes(normalTextAttributes, for: UIControlState())
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(normalTextAttributes, for: .selected)
    }

}
