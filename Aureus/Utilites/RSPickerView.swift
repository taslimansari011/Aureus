//
//  RSPickerView.swift
//  ChiropracticFirstDemo
//
//  Created by Aman gupta on 20/10/18.
//  Copyright © 2018 Finoit. All rights reserved.
//


import UIKit

class RSPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Closures
    private var callBack = {(index: NSInteger, response: Any?) -> () in
    }
    
    // MARK: - Variables
    var arrData: [Any]!
    var strKey: String?
    var pickerView: UIPickerView!
    var viewContainer: UIView!
    
    // MARK: - Initializer Methods
    convenience init(view: UIView, arrayList list: [Any], keyValue key: String?, handler completionBlock: @escaping (_ index: NSInteger, _ response: Any?) -> ()) {
        kSharedAppDelegate.window!.endEditing(true)
        
        let rect = view.bounds
        self.init(frame: rect)
        
        //let screenHeight = kScreenHeight
        arrData = list
        strKey = key
        
        let viewHt = rect.size.height
        let cHt = 201
        let yValue = viewHt - CGFloat(cHt) - pickerTopMargin
        viewContainer = UIView(frame: CGRect(x: 0, y: viewHt, width: kScreenWidth, height: CGFloat(cHt)))
        
        pickerView = UIPickerView(frame: CGRect(x: 2, y: 35, width: kScreenWidth, height: 162))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
        viewContainer.addSubview(pickerView)
        
        
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
        viewHeader.backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        
        let btnCancel = getButton(xValue: 1.0, buttonTitle: "Cancel")
        viewHeader.addSubview(btnCancel)
        
        let btnDone = getButton(xValue: kScreenWidth - 71.0, buttonTitle: "Done")
        viewHeader.addSubview(btnDone)
        
        viewContainer.addSubview(viewHeader)
        self.addSubview(viewContainer)
        
        view.addSubview(self)
        callBack = completionBlock
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            var frame = self.viewContainer.frame
            frame.origin.y = yValue
            self.viewContainer.frame = frame
        }, completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func getButton(xValue: CGFloat, buttonTitle title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: xValue, y: 1, width: 70, height: 35)
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        if (title == "Cancel") {
            button.addTarget(self, action: #selector(tapCancel(sender:)), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(tapDone(sender:)), for: .touchUpInside)
        }
        return button
    }
    
    // MARK: - Actions
    @objc func tapCancel(sender: UIButton) {
        kSharedAppDelegate.window!.endEditing(true)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            var frame = self.viewContainer.frame
            frame.origin.y = self.frame.size.height
            self.viewContainer.frame = frame
        }) { (finished) in
            self.callBack(-1, nil)
            self.removeFromSuperview()
        }
    }
    
    @objc func tapDone(sender: UIButton) {
        kSharedAppDelegate.window!.endEditing(true)
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: .beginFromCurrentState, animations: {
            var frame = self.viewContainer.frame
            frame.origin.y = self.frame.size.height
            self.viewContainer.frame = frame
        })
        { (finished) in
            if finished {
                if self.arrData.count > 0 {
                    if self.strKey == nil {
                        self.callBack(self.pickerView.selectedRow(inComponent: 0), "\(self.arrData[self.pickerView.selectedRow(inComponent: 0)])".capitalized)
                    } else {
                        if let array = self.arrData {
                            self.callBack(self.pickerView.selectedRow(inComponent: 0), "\(SharedClass.sharedInstance.getDictionary(dictData: array[self.pickerView.selectedRow(inComponent: 0)]))".capitalized)
                        }
                    }
                } else {
                    self.callBack(-1, nil)
                }
                self.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: - Picker View Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if strKey == nil {
            return "\(arrData[row])".capitalized
        } else {
            let dictData = SharedClass.sharedInstance.getDictionary(dictData: arrData[row])
            return "\(dictData[strKey!])".capitalized
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    }
    
}

