//
//  MapCell.swift
//  Insert Dreams Here
//
//  Created by JY on 2018/3/2.
//  Copyright © 2018年 Mavey Ma. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {
    @IBOutlet weak var dreamTitleLabel: UILabel!
    @IBOutlet weak var dreamContentLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
