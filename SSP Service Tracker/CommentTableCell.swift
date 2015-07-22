//
//  CommentTableCell.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/19/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

//Specifies the layout of a custom cell for the comment feed
class CommentTableCell: UITableViewCell {

    
    @IBOutlet weak var commentText: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        
        commentText.layer.cornerRadius = 10
        commentText.layer.borderWidth = 0.5
        commentText.layer.borderColor = borderColor.CGColor
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
