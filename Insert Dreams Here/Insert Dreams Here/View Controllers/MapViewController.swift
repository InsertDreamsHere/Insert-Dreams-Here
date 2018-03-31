//
//  MapViewController.swift
//  Insert Dreams Here
//
//  Created by JY on 2018/3/2.
//  Copyright © 2018年 Mavey Ma. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var mapTableView: UITableView!
//    var topOffset: CGFloat = 0.0
//    private let kTopWindowAspectRatio : CGFloat = 3.0/4.0
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mapTableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapTableView.dataSource = self
        mapTableView.contentInset = UIEdgeInsets(top: 700, left: 0, bottom: 0, right: 0)
        mapTableView.contentOffset = CGPoint(x:0, y:1)
        // Do any additional setup after loading the view.
        //mapTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        mapTableView.estimatedRowHeight = 150
        mapTableView.rowHeight = UITableViewAutomaticDimension
        

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // Calculate the top offset and set it if not corectly set
//        if(topOffset != CGFloat(mapTableView.bounds.width) * kTopWindowAspectRatio) {
//            topOffset = CGFloat(mapTableView.bounds.width) * kTopWindowAspectRatio
//            // Setup table view insets and offsets
//            let topInset = CGFloat(mapTableView.bounds.height)
//            mapTableView.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
//            mapTableView.contentOffset = CGPoint(x:0, y:-topOffset)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
