//
//  DueListTableViewCell.swift
//  Dues
//
//  Created by DadiousA on 16/11/12.
//  Copyright © 2016年 DadiousA. All rights reserved.
//

import UIKit

class DueListTableViewCell: UITableViewCell {

    @IBOutlet weak var DueNameLabel: UILabel!
    @IBOutlet weak var DeadlineLabel: UILabel!
     
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
