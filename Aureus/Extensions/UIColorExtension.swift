//
//  UIColorExtension.swift
//  ChiropracticeFirst
//
//  Created by Vaibhav Singla on 10/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static let appThemeColor = UIColor.init(red: 235/255.0, green: 180/255.0, blue: 70/255.0, alpha: 1)
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    static var rescheduledLightGray: UIColor {
        return colorWithParameters(red: 207, green: 207, blue: 207)
    }
    
    class func colorWithParameters(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
}
