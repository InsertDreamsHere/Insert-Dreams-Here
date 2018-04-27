//
//  LoginViewController.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboard()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onTap(_ sender: Any) {
    view.endEditing(true)
  }
  @IBAction func onSignUp(_ sender: Any) {
    registerUser()
  }
  
  @IBAction func onLogIn(_ sender: Any) {
    loginUser()
  }
  
  func createProfile(){
    Profile.createProfile(withLocation: "Monterey", withBio: "bio is empty", withImage: nil, withCompletion: { (success, error) in
      if success {
        print("Great new profile!")
      } else if let e = error as NSError? {
        print(e.localizedDescription)
        print("Something went wrong with your profile creation.")
      }
    })
  }
  func registerUser() {
    if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
      self.popUpMessage(title: "Whoops!", message: "Username and password cannot be left empty.", confirmation: "OK")
    } else {
      
      // initialize a user object
      let newUser = PFUser()
      
      // set user properties
      newUser.username = usernameTextField.text
      //newUser.email = emailLabel.text
      newUser.password = passwordTextField.text
      
      // call sign up function on the object
      newUser.signUpInBackground { (success: Bool, error: Error?) in
        if let error = error {
          print(error.localizedDescription)
          self.popUpMessage(title: "Failed to sign up.", message: error.localizedDescription, confirmation: "OK")
        } else {
          self.createProfile()
          print("Yay, created new user!")
          self.performSegue(withIdentifier: "AuthenticatedLoginSegue", sender: nil)
          // manually segue to logged in view
        }
      }
    }
  }
  
  func loginUser() {
    let username = usernameTextField.text ?? ""
    let password = passwordTextField.text ?? ""
    
    PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
      if let error = error {
        print("User log in failed: \(error.localizedDescription)")
        self.popUpMessage(title: "Failed to log in.", message: error.localizedDescription, confirmation: "OK")
      } else {
        print("You're logged in!")
        self.performSegue(withIdentifier: "AuthenticatedLoginSegue", sender: nil)
        // display view controller that needs to shown after successful login
      }
    }
  }
  
  func popUpMessage(title: String, message: String, confirmation: String) {
    let alertControllerError = UIAlertController(title: title, message: message, preferredStyle: .alert)
    // create a cancel action
    let cancelAction = UIAlertAction(title: confirmation, style: .cancel) { (action) in
      // handle cancel response here. Doing nothing will dismiss the view.
    }
    // add the cancel action to the alertController
    alertControllerError.addAction(cancelAction)
    present(alertControllerError, animated: true)
  }
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

extension UITextField{
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
    }
  }
}

