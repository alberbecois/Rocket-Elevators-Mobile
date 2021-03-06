//
//  ViewController.swift
//  Rocket Elevators Mobile
//
//  Created by Joshua Knutson on 2020-05-05.
//  Copyright © 2020 Joshua Knutson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, APIManagerDelegate {

    @IBOutlet weak var employeeEmail: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    
    var apimanager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeEmail.delegate = self
        apimanager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        employeeEmail.endEditing(true)
        apimanager.getLogin(email: employeeEmail.text!)
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        employeeEmail.endEditing(true)
        apimanager.getLogin(email: employeeEmail.text!)
        return true
    }
    
    func didUpdateLogin(login: LoginModel) {
        if login.valid {
            performSegue(withIdentifier: "elevatorSegue", sender: self)
        } else {
            loginLabel.textColor = UIColor.red
            loginLabel.text = "Invalid email, please try again."
        }
    }
}

