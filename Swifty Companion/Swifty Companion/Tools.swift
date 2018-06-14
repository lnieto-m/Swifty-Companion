//
//  Tools.swift
//  Swifty Companion
//
//  Created by Luis NIETO MUNOZ on 6/14/18.
//  Copyright © 2018 42. All rights reserved.
//

import Foundation

struct User: CustomStringConvertible {
    let imageURL: String
    let name: String
    let login: String
    let level: String
    let location: String
    let skills: [(String, String)]
    let projects: [(String, String, Bool)]
    var description: String {
        return ("\(name)")
    }
}
