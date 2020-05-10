//
//  Elevator.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import Foundation

struct Elevator {
    let id: Int
    let serial: Int
    let model: String
    let type: String
    let status: String
    
    init(id: Int, serial: Int, model: String, type: String, status: String) {
        self.id = id
        self.serial = serial
        self.model = model
        self.type = type
        self.status = status
    }
}
