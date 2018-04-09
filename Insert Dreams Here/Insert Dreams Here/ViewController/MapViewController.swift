//
//  MapViewController.swift
//  Insert Dreams Here
//
//  Created by JY on 2018/3/2.
//  Copyright © 2018年 Mavey Ma. All rights reserved.
//

import UIKit
import Parse

class MapViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var mapTableView: UITableView!
    var Dreams: [PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapTableView.dataSource = self
        mapTableView.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
        mapTableView.contentOffset = CGPoint(x: 0, y: 1)
        
        var DreamData = PFQuery(className: "Dream")
        DreamData.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.Dreams = objects
                    for dream in self.Dreams {
                        print(dream["body"])
                    }
                    self.mapTableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of Dreams: !@#!@$!@#!@")
        print(self.Dreams.count)
        return Dreams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mapTableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
        let Dream = Dreams[indexPath.row]
        cell.dreamContentLabel.text = Dream["body"] as? String
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
