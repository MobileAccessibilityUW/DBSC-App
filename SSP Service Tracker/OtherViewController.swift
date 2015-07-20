//
//  OtherViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        self.view.layer.borderWidth = 0.5
        self.view.layer.borderColor = borderColor.CGColor
        self.view.layer.cornerRadius = 5.0
        
        commentBox.layer.borderWidth = 0.5
        commentBox.layer.borderColor = borderColor.CGColor
        commentBox.layer.cornerRadius = 1.0
        
        commentsTable.backgroundColor = borderColor
        
        submitButton.layer.cornerRadius = 3.0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        if commentBox.text != "" {
            
            
            comments.insert(commentBox.text, atIndex: 0)
            /*
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            
            commentTimes.insert("\(hour):\(minutes)", atIndex: 0)
            */
            
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            commentTimes.insert(formatter.stringFromDate(date), atIndex: 0)
            
            commentBox.text = ""
            
            commentsTable.reloadData()
            
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCellWithIdentifier("CommentTableCell", forIndexPath: indexPath) as! CommentTableCell
        
        tableCell.commentTextView.text = comments[indexPath.row]
        
        tableCell.timeLabel.text = commentTimes[indexPath.row]
        
        return tableCell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
