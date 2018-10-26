//
//  CommonButton.swift
//  Aureus
//
//  Created by Taslim Ansari on 22/10/18.
//

import UIKit
import Foundation

class CommonButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.appThemeColor
        self.titleLabel?.textColor = .white
    }
}
