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
  @IBOutlet weak var profilePicture: UIImageView!
  
  @IBOutlet weak var timeLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    bodyLabel.numberOfLines = 5
    authorLabel.numberOfLines = 1
    titleLabel.numberOfLines = 3
  }
}
