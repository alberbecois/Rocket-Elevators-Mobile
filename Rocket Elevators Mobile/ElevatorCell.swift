//
//  ElevatorCell.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import UIKit

class ElevatorCell: UITableViewCell {

    @IBOutlet weak var elevatorSerial: UILabel!
    @IBOutlet weak var elevatorStatus: UILabel!
    
    func setElevator(elevator: Elevator) {
        elevatorSerial.text = String(elevator.serial)
        elevatorStatus.text = elevator.status
    }
}
