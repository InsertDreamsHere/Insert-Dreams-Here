//
//  LoginViewController.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onTap(_ sender: Any) {
    view.endEditing(true)
  }
  @IBAction func onSignUp(_ sender: Any) {
    print("Yay, created new user!")
    self.performSegue(withIdentifier: "AuthenticatedLoginSegue", sender: nil)
  }
  
  @IBAction func onLogIn(_ sender: Any) {
    print("You're logged in!")
    self.performSegue(withIdentifier: "AuthenticatedLoginSegue", sender: nil)
  }
  
}
