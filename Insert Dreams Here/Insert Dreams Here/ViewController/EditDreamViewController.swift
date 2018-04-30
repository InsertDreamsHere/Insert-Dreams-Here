//
//  EditDreamViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/23/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class EditDreamViewController: UIViewController {

    @IBOutlet weak var dreamTitle: UITextView!
    @IBOutlet weak var dreamBody: UITextView!
    var dTitle = ""
    var dBody = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dreamTitle.text = dTitle
        dreamBody.text = dBody
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func updateDream(_ sender: Any) {
      let query = PFQuery(className:"Dream")
        query.whereKey("body", equalTo: dBody)
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Dream.")
                // Do something with the found objects
                objects![0]["title"] = self.dreamTitle.text as String
                objects![0]["body"] = self.dreamBody.text as String
                print("edit Dream")
                print(objects![0]["body"])
                objects![0].saveInBackground()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            
        })
    }
    @IBAction func deleteDream(_ sender: Any) {
        //NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
      let query = PFQuery(className:"Dream")
        query.whereKey("body", equalTo: dBody)
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Dream.")
                // Do something with the found objects
                
                objects![0].deleteInBackground()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            
        })
    }
}
