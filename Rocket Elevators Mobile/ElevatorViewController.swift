//
//  ElevatorViewController.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import UIKit

class ElevatorViewController: UIViewController {
    
    var selectedElevator: Int = 0
    @IBOutlet weak var tableView: UITableView!
    var elevators: [Elevator] = []
    let listURL = "https://rocketrestapi.azurewebsites.net/api/Elevators/ListNonOperational"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Elevators"
        elevators = getElevatorList()!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! StatusViewController
        vc.elevator = self.elevators[selectedElevator]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedElevator = indexPath.row
        performSegue(withIdentifier: "StatusSegue", sender: self)
    }
    
    func getElevatorList() -> [Elevator]? {
        var tempElevators: [Elevator] = []
        if let url = URL(string: listURL) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let sem = DispatchSemaphore.init(value: 0)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                defer { sem.signal() }
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    tempElevators =  self.parseJSON(elevatorData: safeData)!
                }
            }
            task.resume()
            sem.wait()
        }
        return tempElevators
    }
    
    func parseJSON(elevatorData: Data) -> [Elevator]? {
        let decoder = JSONDecoder()
        var elevatorList: [Elevator] = []
        do {
            let decodedData = try decoder.decode([ElevatorData].self, from: elevatorData)
            for item in decodedData {
                elevatorList.append(Elevator(id: item.id, serial: item.serial_number, model: item.model, type: item.elevator_type, status: item.status))
            }
            return elevatorList
        } catch {
            print(error)
            return nil
        }
    }
}

extension ElevatorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elevators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elevator = elevators[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElevatorCell") as! ElevatorCell
        
        cell.setElevator(elevator: elevator)
        
        return cell
    }
}
