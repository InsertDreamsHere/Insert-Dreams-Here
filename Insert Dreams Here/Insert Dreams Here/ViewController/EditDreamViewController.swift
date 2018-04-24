//
//  EditDreamViewController.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/23/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class EditDreamViewController: UIViewController {

    @IBOutlet weak var dreamTitle: UITextView!
    @IBOutlet weak var dreamBody: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelEditDream(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
    }
    @IBAction func updateDream(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
    }
    @IBAction func deleteDream(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toProfile"), object: nil)
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
