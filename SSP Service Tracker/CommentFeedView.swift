//
//  CommentFeedView.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/17/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class CommentFeedView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var commentXib: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentBox: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("CommentsFeedView", owner: self, options: nil)
        self.addSubview(self.commentXib)
        
        //commentTableView.registerNib(<#nib: UINib#>, forCellReuseIdentifier: <#String#>)
    }
    
    override func awakeFromNib() {
        
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor.CGColor
        self.layer.cornerRadius = 5.0
        
        commentBox.layer.borderWidth = 0.5
        commentBox.layer.borderColor = borderColor.CGColor
        commentBox.layer.cornerRadius = 1.0
        
        self.commentTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return 3
        //return comments.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        tableCell.textLabel!.text = "Hi" //comments[indexPath.row]
        
        return tableCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.endEditing(true)
        
    }


}
