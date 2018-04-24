//
//  EditProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/23/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {

    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var userPicture: UIImageView!
    var Profiles: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUserProfile()
    }
    func getUserProfile(){
        
        print("current user")
        print(PFUser.current()!)
        
        
        let query = PFQuery(className: "Profile")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.includeKey("author.username")
        
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                // Do something with the found objects
                if let objects = objects {
                    self.Profiles = objects
                    
                    self.username.text = PFUser.current()!["username"] as? String
                    self.userBio.text = self.Profiles[0]["bio"] as? String
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })
    }
    func setUserProfile(){
    
        let query = PFQuery(className: "Profile")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.includeKey("author.username")
        
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                // Do something with the found objects
                if let objects = objects {
                    self.Profiles = objects
                    
                    PFUser.current()!["username"] = self.username.text
                    self.Profiles[0]["bio"] = self.userBio.text
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelEdit(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
    }
    
    @IBAction func updateEdit(_ sender: Any) {
        setUserProfile()
        NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
    }
    

}