//
//  ProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var biogrophyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
    override func viewWillAppear(_ animated: Bool) {
        Profile.createProfile(withLocation: "Monterey", withBio: "bio is empty", withImage: nil, withCompletion: { (success, error) in
            if success {
                print("Great new dream!")
            } else if let e = error as NSError? {
                print(e.localizedDescription)
                print("Something went wrong with your dream post.")
            }
        })
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogout(_ sender: Any) {
    print("Clicked logout")
    NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
  }
  
    @IBAction func onEdit(_ sender: Any) {
    }
}
