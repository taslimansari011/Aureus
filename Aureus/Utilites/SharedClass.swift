//
//  SharedClass.swift
//  ChiropracticFirstDemo
//
//  Created by Aman gupta on 20/10/18.
//  Copyright © 2018 Finoit. All rights reserved.
//

import UIKit


class SharedClass: NSObject {
    
    // MARK: - Variables
    static let sharedInstance = SharedClass()
    
    // MARK: - Initializer Methods
    private override init() {
        
    }
    
    // MARK: - Helper methods
    func getDictionary(dictData: Any?) -> [String: Any] {
        guard let dict = dictData as? Dictionary<String, Any> else {
            guard let arr = dictData as? [Any] else {
                return ["":""]
            }
            return getDictionary(dictData: arr.count > 0 ? arr[0] : ["":""])
        }
        return dict
    }
    
}
