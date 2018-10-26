//
//  ProgressChartViewController.swift
//  GenorocityUserSwift
//
//  Created by Taslim Ansari on 7/24/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import WebKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var detailsLabel1: UILabel!
    @IBOutlet weak var detailsLabel2: UILabel!
    
    @IBOutlet weak var teacherPiano: UILabel!
    @IBOutlet weak var teacherViolin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userImageView.layer.cornerRadius = 50
        makeAttributed(str: detailsLabel1.attributedText! as! NSMutableAttributedString, seperator: "#")
        makeAttributed(str: detailsLabel2.attributedText! as! NSMutableAttributedString, seperator: "#")
        makeTeacherLabelAttributed(str: teacherPiano.attributedText! as! NSMutableAttributedString)
        makeTeacherLabelAttributed(str: teacherViolin.attributedText! as! NSMutableAttributedString)
    }
    
    func makeAttributed(str: NSMutableAttributedString, seperator: String) {
        let grayAtt = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        for subString in str.string.components(separatedBy: " ") {
            for (index, component) in subString.components(separatedBy: seperator).enumerated() {
                if index % 2 != 0 {
                    let range = (str.string as NSString).range(of: component)
                    str.addAttributes(grayAtt, range: range)
                }
            }
        }
    }
    
    func makeTeacherLabelAttributed(str: NSMutableAttributedString) {
        let blackAtt = [NSAttributedStringKey.foregroundColor: UIColor.black]
        for (index, component) in str.string.components(separatedBy: "-").enumerated() {
            if index % 2 == 0 {
                let range = (str.string as NSString).range(of: component)
                str.addAttributes(blackAtt, range: range)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
