//
//  ViewController.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let uid = "8803aad0b824d7fa57bbb94a17219d65437d5073c3d42e5deed993585c67fe78"
    let secret = "0d84a4e2bf4ddb42ecf3ed061b6a0da7ace3e1d2f8026be494e3c982a61f33bb"
    var token = ""
    var user: User?
    
    @IBOutlet weak var LoginField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logApp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadProfile" {
            if let dest = segue.destination as? UserViewController {
                dest.user = self.user
            }
        }
    }

//     self.performSegue(withIdentifier: "loadProfile", sender: nil)
    
    
    @IBAction func SearchButton(_ sender: UIButton) {
        if let text = LoginField.text, text != "" {
            SearchUser(login: text)
        }
    }
    
    func logApp() {
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8.", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(uid)&client_secret=\(secret)".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let d = dic["access_token"] {
                            self.token = d as! String
                            print(d)
                        } else {
                            print("Authentification failed.")
                        }
                    }
                } catch (let e) {
                    print(e)
                }
            }
        }
        task.resume()
    }
    
    func SearchUser(login: String) {
        let url = NSURL(string: "https://api.intra.42.fr/v2/users/\(login)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(dic)
                        guard
                            let login = dic["login"],
                            let name = dic["displayname"],
                            let location = dic["location"],
                            let cursusList = dic["cursus_users"],
                            let imageURL = dic["image_url"]
                            else {
                                print("error lol")
                                return
                        }
                        self.user = User(imageURL: imageURL as! String,
                                         name: name as! String,
                                         login: login as! String,
                                         level: "12",
                                         location: location as! String,
                                         skills: [],
                                         projects: [])
                        self.performSegue(withIdentifier: "loadProfile", sender: nil)
                    }
                } catch (let e) {
                    print(e)
                }
            }
        }
        task.resume()
    }
}

