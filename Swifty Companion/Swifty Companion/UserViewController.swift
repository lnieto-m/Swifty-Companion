//
//  UserViewController.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var UserPhoto: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Login: UILabel!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Location: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = user {
            Name.text = data.name
            Login.text = data.login
            Level.text = data.level
            Location.text = data.location
            if let url = NSURL(string: data.imageURL) {
                if let data = NSData(contentsOf: url as URL) {
                    UserPhoto.image = UIImage(data: data as Data)
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
