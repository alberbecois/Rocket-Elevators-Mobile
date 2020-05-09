//
//  LoginModel.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import Foundation

struct LoginModel {
    let fname: String
    let lname: String
    let email: String
    let valid: Bool
    
    var welcomeString: String {
        return "Welcome back \(fname) \(lname), see below elevators requiring service"
    }
    
    var loginString: String {
        return "You are currently logged in as \(email)"
    }
    
}
