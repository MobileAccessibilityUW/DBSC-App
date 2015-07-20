//
//  CommentCell.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/18/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //@IBOutlet weak var commentText: UITextView!
    @IBOutlet var commentXib: UITableViewCell!
    @IBOutlet weak var timeText: UILabel!
    
    /*required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("CommentCell", owner: self, options: nil)
        self.addSubview(self.commentXib)
        
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
