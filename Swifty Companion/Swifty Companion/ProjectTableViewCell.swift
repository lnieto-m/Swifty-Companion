//
//  ProjectTableViewCell.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Grade: UILabel!
    var project: (String, String, Bool)? {
        didSet {
            if let proj = project {
                Name.text = proj.0
                Grade.text = proj.1
                if proj.2 {
                    Grade.textColor = UIColor.green
                } else {
                    Grade.textColor = UIColor.red
                }
            }
        }
    }

}
