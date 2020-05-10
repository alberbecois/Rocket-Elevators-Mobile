//
//  StatusViewController.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var elevatorSerial: UILabel!
    @IBOutlet weak var elevatorModel: UILabel!
    @IBOutlet weak var elevatorType: UILabel!
    @IBOutlet weak var elevatorStatus: UILabel!
    
    @IBAction func setToActive(_ sender: Any) {
        let urlString = "https://rocketrestapi.azurewebsites.net/api/Elevators/\(elevator.id)/status"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let parameters: [String: Bool] = ["active": true]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            var httpResponse: HTTPURLResponse?
            
            let sem = DispatchSemaphore.init(value: 0)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                defer { sem.signal() }
                if error != nil {
                    print(error!)
                    return
                }
                httpResponse = response as? HTTPURLResponse
            }
            task.resume()
            sem.wait()
            if httpResponse!.statusCode == 204 {
                let alert = UIAlertController(title: "Update Status:", message: "Update successful. Return to login?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Update Status:", message: "Update failed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    
    var elevator = Elevator(id: 0, serial: 0, model: "", type: "", status: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elevatorSerial.text = "Elevator: \(String(elevator.serial))"
        elevatorModel.text = "Model: \(elevator.model)"
        elevatorType.text = "Type: \(elevator.type)"
        if elevator.status != "active" {
            elevatorStatus.textColor = UIColor.red
            elevatorStatus.text = "Status: \(elevator.status)"
        } else {
            elevatorStatus.textColor = UIColor.green
            elevatorStatus.text = "Status: \(elevator.status)"
        }
        // Do any additional setup after loading the view.
    }
        

}
