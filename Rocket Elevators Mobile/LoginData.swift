//
//  LoginData.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import Foundation

struct LoginData: Decodable {
    let last_name: String
    let first_name: String
    let email: String
}
