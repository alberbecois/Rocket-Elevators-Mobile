//
//  ElevatorData.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import Foundation

struct ElevatorData: Decodable {
    let id: Int
    let serial_number: Int
    let model: String
    let elevator_type: String
    let status: String
}
