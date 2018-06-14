//
//  UserViewController.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SkillsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SkillsTable.dequeueReusableCell(withIdentifier: "Skills") as! SkillTableViewCell
        cell.Skill = SkillsList[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var XPBar: UIProgressView!
    @IBOutlet weak var UserPhoto: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Login: UILabel!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var SkillsTable: UITableView!
    
    var user: User?
    var SkillsList: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        XPBar.transform = XPBar.transform.scaledBy(x: 1, y: 20)
        
        if let data = user {
            SkillsList = data.skills
            Name.text = data.name
            Login.text = data.login
            Level.text = "Level \(data.level.0) - \(data.level.1)%"
            Location.text = data.location
            if let url = NSURL(string: data.imageURL) {
                if let data = NSData(contentsOf: url as URL) {
                    UserPhoto.image = UIImage(data: data as Data)
                }
            }
            XPBar.progress = Float(data.level.1)! / 100
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
