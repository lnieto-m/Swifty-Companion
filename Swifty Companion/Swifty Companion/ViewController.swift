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
    
    func getUserLevel(_ cursusList: Any) -> (String, String) {
        if let cursus = cursusList as? NSArray {
            for value in cursus {
                if let current = value as? NSDictionary {
                    if let id = current["cursus_id"] as? NSInteger, id == 1 {
                        let lvl = (current["level"] as? NSNumber)!
                        let splitlvl = String(format: "%.2f", lvl.floatValue).split(separator: ".")
                        if splitlvl.count > 1 {
                            print(splitlvl[1])
                            return (String(splitlvl[0]), String(splitlvl[1]))
                        } else {
                            return (String(splitlvl[0]), "0")
                        }
                    }
                }
            }
        }
        return ("0", "0")
    }
    
    func getUserSkills(_ cursusList: Any) -> [(String, String)] {
        var skillsList: [(String, String)] = []
        if let cursus = cursusList as? NSArray {
            for value in cursus {
                if let current = value as? NSDictionary {
                    if let id = current["cursus_id"] as? NSInteger, id == 1 {
                        if let skills = current["skills"] as? NSArray {
                            for value in skills {
                                if let skill = value as? NSDictionary, let level = skill["level"] as? NSNumber, let name = skill["name"] as? String {
                                    skillsList.append((String(format: "%.2f", level.floatValue), name))
                                }
                            }
                        }
                    }
                }
            }
        }
        return skillsList
    }
    
    func getUserProjects(_ projectList: Any) -> [(String, String, Bool)] {
        var projects: [(String, String, Bool)] = []
        if let list = projectList as? NSArray {
            for value in list {
                guard
                    let current = value as? NSDictionary,
                    let status = current["status"] as? String,
                    let validated = current["validated?"] as? NSInteger,
                    let proj = current["project"] as? NSDictionary,
                    let name = proj["name"] as? String,
                    let grade = current["final_mark"] as? NSInteger,
                    let cursus = current["cursus_ids"] as? NSArray,
                    let id = cursus[0] as? NSInteger
                else {
                    continue
                }
                if let _ = proj["parent_id"] as? NSNumber {
                    continue
                }
                if status == "finished" && id == 1 {
                    if validated == 1 {
                        projects.append((name, grade.description, true))
                    } else {
                        projects.append((name, grade.description, false))
                    }
                }
            }
        }
        return projects
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
                            let imageURL = dic["image_url"],
                            let projectList = dic["projects_users"]
                            else {
                                print("error lol")
                                return
                        }
                        var uLocation = location as? String
                        if uLocation == nil {
                            uLocation = "unavalaible"
                        }
                        if let loc = uLocation {
                            self.user = User(imageURL: imageURL as! String,
                                             name: name as! String,
                                             login: login as! String,
                                             level: self.getUserLevel(cursusList),
                                             location: loc,
                                             skills: self.getUserSkills(cursusList),
                                             projects:self.getUserProjects(projectList))
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "loadProfile", sender: nil)
                            }
                        }
                    }
                } catch (let e) {
                    print(e)
                }
            }
        }
        task.resume()
    }
}

