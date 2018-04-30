//
//  EditProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/23/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Toucan

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var userBio: UITextView!
    @IBOutlet weak var userPicture: UIImageView!
    
    var Profiles: [PFObject] = []
    var bio = ""
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBio.text = bio
        //userPicture = image
        username.text = PFUser.current()!["username"] as? String
    }
    
    @IBAction func onTapImageView(_ sender: Any) {
        // Instantiate a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        //vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // When the user finishes taking the picture, UIImagePickerController returns a dictionary that contains the image and some other meta data. The full set of keys are listed here.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: CGSize(width: 258, height: 258))
        
        self.userPicture.image = resizedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateEdit(_ sender: Any) {
        let query = PFQuery(className:"Profile")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) Profile.")
                objects![0]["bio"] = self.userBio.text as String
                objects![0]["media"] = Profile.getPFFileFromImage(image: self.userPicture.image)
                objects![0].saveInBackground()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                print("Error: \(error!)")
            }
            
        })
    }
}
