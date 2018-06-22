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
        if tableView == SkillsTable {
            return SkillsList.count
        } else {
            return ProjectsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == SkillsTable {
            let cell = SkillsTable.dequeueReusableCell(withIdentifier: "Skills") as! SkillTableViewCell
            cell.Skill = SkillsList[indexPath.row]
            return cell
        } else {
            let cell = ProjectsTable.dequeueReusableCell(withIdentifier: "Projects") as! ProjectTableViewCell
            cell.project = ProjectsList[indexPath.row]
            return cell
        }
    }
    
    func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result
    }

    @IBOutlet weak var UserPhoto: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Login: UILabel!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var SkillsTable: UITableView!
    @IBOutlet weak var ProjectsTable: UITableView!
    
    var user: User?
    var SkillsList: [(String, String)] = []
    var ProjectsList: [(String, String, Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SkillsTable.layer.cornerRadius = 10
        SkillsTable.clipsToBounds = true
        ProjectsTable.layer.cornerRadius = 10
        ProjectsTable.clipsToBounds = true
        
        if let data = user {
            ProjectsList = data.projects
            SkillsList = data.skills
            Name.text = data.name
            Login.text = data.login
            Level.text = "Level \(data.level.0) - \(data.level.1)%"
            Location.text = data.location
            if let url = NSURL(string: data.imageURL) {
                if let data = NSData(contentsOf: url as URL) {
                    guard let image = UIImage(data: data as Data) else {
                        return
                    }
                    let cropRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
                    if let lol = crop(image: image, cropRect: cropRect) {
                        UserPhoto.image = lol
                        UserPhoto.layer.cornerRadius = UserPhoto.frame.height / 2
                        UserPhoto.clipsToBounds = true
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
