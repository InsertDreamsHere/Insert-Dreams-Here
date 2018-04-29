//
//  ProfileViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var biogrophyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDreamTable: UITableView!
    var Dreams: [PFObject] = []
    var Profiles: [PFObject] = []
    var refreshControl: UIRefreshControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    userDreamTable.dataSource = self
    //userDreamTable.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
    userDreamTable.contentOffset = CGPoint(x: 0, y: 1)
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(ProfileViewController.didPullToRefresh(_:)), for: .valueChanged)
    userDreamTable.insertSubview(refreshControl, at: 0)

    getTimelineDreams()
    getUserProfile()

  }

    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
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
                    //let currentUser = self.Profiles[0]
                    //print("self.Profiles")
                    //print(currentUser)
                    //print(PFUser.current())

                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                    let myString = formatter.string(from: PFUser.current()!.createdAt!)
                    // convert your string to date
                    let yourDate = formatter.date(from: myString)
                    //then again set the date format whhich type of output you need
                    formatter.dateFormat = "dd-MMM-yyyy"
                    // again convert your date to string
                    let myStringafd = formatter.string(from: yourDate!)

                    let join = "Joined "

                    self.nameLabel.text = PFUser.current()!["username"] as? String
                    self.dateJoinedLabel.text = join + myStringafd
                    self.userLocationLabel.text = self.Profiles[0]["location"] as? String
                    self.biogrophyLabel.text = self.Profiles[0]["bio"] as? String

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
        //print("date:")
        //print(Dream.createdAt)

        let myString = formatter.string(from: Dream.createdAt!)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)

        cell.dateLabel.text =  myStringafd
        //print("Dream title")
        //print(Dream["title"] as? String)
        if(Dream["title"] as? String == nil) {
            cell.titleLabel.text = "No Title"
        } else {
            cell.titleLabel.text = Dream["title"] as? String
        }

        let username = PFUser.current()!.username as! String
        cell.authorLabel.text = "by " + username
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

    @IBAction func onEdit(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("onEdit"), object: nil)
    }
    //Mark - UITableViewDelegate
    /*var selectedDream: Dream
    
    func tableView( tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = Dreams[IndexPath]
        let dream = userDreamTable
    }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDreamDeatail"){
            var selectedRowIndex = self.userDreamTable.indexPathForSelectedRow
            var moveVC:EditDreamViewController = segue.destination as! EditDreamViewController
            print("selected Dream")
            moveVC.dTitle = Dreams[(selectedRowIndex?.row)!]["title"] as! String
            moveVC.dBody = Dreams[(selectedRowIndex?.row)!]["body"] as! String
            //print(Dreams[(selectedRowIndex?.row)!]["body"])
            
        }
    }
}
