//
//  ProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    //var Profiles: [PFObject] = []
  
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var biogrophyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    var UserProfile = PFQuery(className: "Profile")
//    UserProfile.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
//        if error == nil {
//            // The find succeeded.
//            print("Successfully retrieved \(objects!.count) scores.")
//            // Do something with the found objects
//            if let objects = objects {
//                self.Dreams = objects
//                //                    for dream in self.Dreams {
//                //                        print(dream["body"])
//                //                    }
//                self.mapTableView.reloadData()
//            }
//        } else {
//            // Log details of the failure
//            print("Error: \(error!)")
//        }
//    })
    // Do any additional setup after loading the view.
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
