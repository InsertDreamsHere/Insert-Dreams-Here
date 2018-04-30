//
//  ProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var dreamCount: UILabel!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var biogrophyLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateJoinedLabel: UILabel!
  @IBOutlet weak var userLocationLabel: UILabel!
  @IBOutlet weak var userDreamTable: UITableView!
  @IBOutlet weak var dreamWordLabel: UILabel!
  var Dreams: [PFObject] = []
  var Profiles: [PFObject] = []
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userDreamTable.dataSource = self
    userDreamTable.rowHeight = UITableViewAutomaticDimension
    userDreamTable.estimatedRowHeight = 200
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(ProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
    userDreamTable.insertSubview(refreshControl, at: 0)
    
    getUserProfile()
    getTimelineDreams()
  }
  
  @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
    getUserProfile()
    getTimelineDreams()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getUserProfile()
    getTimelineDreams()
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
          let currentUser = self.Profiles[0]
          print("self.Profiles")
          print(currentUser)
          //print(PFUser.current())
          
          let formatter = DateFormatter()
          // initially set the format based on your datepicker date
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          
          let myString = formatter.string(from: PFUser.current()!.createdAt!)
          // convert your string to date
          let yourDate = formatter.date(from: myString)
          //then again set the date format whhich type of output you need
          formatter.dateFormat = "MMM dd, yyyy"
          // again convert your date to string
          let myStringafd = formatter.string(from: yourDate!)
          
          let join = "Joined "
          
          self.nameLabel.text = PFUser.current()!["username"] as? String
          self.dateJoinedLabel.text = join + myStringafd
          self.userLocationLabel.text = self.Profiles[0]["location"] as? String
          self.biogrophyLabel.text = self.Profiles[0]["bio"] as? String
          if let imageFile : PFFile = self.Profiles[0]["media"] as? PFFile {
            imageFile.getDataInBackground(block: { (data, error) in
              if error == nil {
                let image = UIImage(data: data!)
                self.profilePic.image = image
                self.profilePic.layer.cornerRadius = self.profilePic.frame.height/2
                self.profilePic.layer.borderWidth = 2
                self.profilePic.layer.borderColor = UIColor.white.cgColor
              } else {
                print(error!.localizedDescription)
              }
            })
          }
          
          let numDream = self.Profiles[0]["dreamCount"] as! Int
          if numDream == 1 {
            self.dreamWordLabel.text = "Dream"
          } else {
            self.dreamWordLabel.text = "Dreams"
          }
          self.dreamCount.text = String(describing: numDream)
        }
      } else {
        // Log details of the failure
        print("Error: \(error!)")
      }
      
    })
    
  }
  
  
  func getTimelineDreams(){
    let query = PFQuery(className: "Dream")
    query.whereKey("author", equalTo: PFUser.current()!)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) Dreams.")
        // Do something with the found objects
        if let objects = objects {
          self.Dreams = objects
          
          for dream in self.Dreams {
            print(dream["body"])
          }
          self.userDreamTable.reloadData()
          self.refreshControl.endRefreshing()
        }
      } else {
        // Log details of the failure
        print("Error: \(error!)")
      }
    })
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("Number of Dreams: !@#!@$!@#!@")
    print(self.Dreams.count)
    return Dreams.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = userDreamTable.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
    let Dream = Dreams[indexPath.row]
    cell.bodyLabel.text = Dream["body"] as? String
    
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let myString = formatter.string(from: Dream.createdAt!)
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    formatter.dateFormat = "MMM dd, yyyy"
    // again convert your date to string
    var myStringafd = formatter.string(from: yourDate!)
    cell.dateLabel.text =  myStringafd
    
    formatter.dateFormat = "h:mm a"
    // again convert your date to string
    myStringafd = formatter.string(from: yourDate!)
    cell.timeLabel.text =  myStringafd
    cell.profilePicture.image = self.profilePic.image
    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
    cell.profilePicture.layer.borderWidth = 2
    cell.profilePicture.layer.borderColor = UIColor.white.cgColor
    cell.locationLabel.text = Dream["location"] as? String
    
    
    if(Dream["title"] as? String == nil) {
      cell.titleLabel.text = "No Title"
    } else {
      cell.titleLabel.text = Dream["title"] as? String
    }
    
    let username = PFUser.current()?.username
    cell.authorLabel.text = "by " + username!
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onLogout(_ sender: Any) {
    print("Clicked logout")
    NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "showDreamDetail"){
      var selectedRowIndex = self.userDreamTable.indexPathForSelectedRow
      let moveVC:EditDreamViewController = segue.destination as! EditDreamViewController
      print("selected Dream")
      moveVC.dTitle = Dreams[(selectedRowIndex?.row)!]["title"] as! String
      print(Dreams[(selectedRowIndex?.row)!]["title"] as! String)
      moveVC.dBody = Dreams[(selectedRowIndex?.row)!]["body"] as! String
      //print(Dreams[(selectedRowIndex?.row)!]["body"] as! String)
      //print(Dreams[(selectedRowIndex?.row)!]["body"])
      
    }
    if(segue.identifier == "showProfileDetail"){
      
      let moveVC:EditProfileViewController = segue.destination as! EditProfileViewController
      moveVC.bio = biogrophyLabel.text!
      moveVC.image = self.profilePic
    }
  }
}
