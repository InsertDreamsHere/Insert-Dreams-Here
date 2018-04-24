//
//  ProfileCell.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/11/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBAction func editDream(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("editDream"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
