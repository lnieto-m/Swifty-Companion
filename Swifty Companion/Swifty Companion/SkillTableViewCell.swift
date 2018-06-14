//
//  SkillTableViewCell.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Progress: UILabel!
    
    var Skill: (String, String)? {
        didSet {
            if let skill = Skill {
                Name.text = skill.1
                Progress.text = skill.0
            }
        }
    }

}
