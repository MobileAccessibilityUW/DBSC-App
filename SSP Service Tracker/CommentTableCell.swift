//
//  CommentTableCell.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/19/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {

    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
