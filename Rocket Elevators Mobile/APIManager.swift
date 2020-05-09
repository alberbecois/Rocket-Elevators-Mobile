//
//  APIManager.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-09.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdateLogin(login: LoginModel)
}

struct APIManager {
    let reURL = "https://rocketrestapi.azurewebsites.net/api/"
    
    var delegate: APIManagerDelegate?
    
    func getLogin(email: String) {
        let urlString = "\(reURL)Employees/Authenticate"
        let parameters: [String: String] = ["email": email]
        performRequest(urlString: urlString, parameters: parameters)
    }
    
    func performRequest(urlString: String, parameters: [String: String]) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var login = LoginModel(fname: "", lname: "", email: "", valid: false) as LoginModel?
            let sem = DispatchSemaphore.init(value: 0)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                defer { sem.signal() }
                if error != nil {
                    print(error!)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 404 {
                        if let safeData = data {
                            login = self.parseJSON(loginData: safeData)
                        }
                    }
                }
            }
            task.resume()
            
            // wait for task
            sem.wait()
            
            self.delegate?.didUpdateLogin(login: login!)
        }
    }
    
    func parseJSON(loginData: Data) -> LoginModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LoginData.self, from: loginData)
            let login = LoginModel(fname: decodedData.first_name, lname: decodedData.last_name, email: decodedData.email, valid: true)
            return login
        } catch {
            print(error)
            return nil
        }
    }
    
}
