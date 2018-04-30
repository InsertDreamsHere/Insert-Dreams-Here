//
//  EditProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/23/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var userPicture: UIImageView!
    var Profiles: [PFObject] = []
    var bio = ""
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userBio.text = bio
        userPicture = image
        username.text = PFUser.current()!["username"] as? String
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userPicture.isUserInteractionEnabled = true
        userPicture.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        self.present(vc, animated: true, completion: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage]
        
        // Do something with the images (based on your use case)
        
        //upload.image = editedImage
        self.userPicture = editedImage as! UIImageView
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateEdit(_ sender: Any) {
        var query = PFQuery(className:"profile")
        print("date joined")
        //print(PFUser.current()?.createdAt)
        query.whereKey("author", equalTo: PFUser.current()!)
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Profile.")
                // Do something with the found objects
                objects![0]["bio"] = self.userBio.text as String
                objects![0].saveInBackground()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            
        })
        
    }
    

}
