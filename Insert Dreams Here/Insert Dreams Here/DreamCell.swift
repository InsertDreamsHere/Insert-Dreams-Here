//
//  DreamCell.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit

class DreamCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
