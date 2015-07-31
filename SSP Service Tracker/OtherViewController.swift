//
//  OtherViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit
import Foundation

//This class is responsible for the comment section which appears in multiple places in a container view
@IBDesignable

class OtherViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBInspectable var borderColor:UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    @IBInspectable var buttonColor:UIColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0)
    
    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        commentsTable.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 1.0, alpha: 1)
        
        //Gives the container for the comment section a border
        
        self.view.layer.borderWidth = 0.75
        self.view.layer.borderColor = borderColor.CGColor
        self.view.layer.cornerRadius = 5.0
        
        //Border for the comment box
        commentBox.layer.borderWidth = 1
        commentBox.layer.borderColor = borderColor.CGColor
        
        //Gets rid of the line between comment cells
        commentsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        commentsTable.backgroundView = nil
        
        //Sets up button styling
        submitButton.layer.borderWidth = 0.75
        submitButton.layer.borderColor = buttonColor.CGColor
        submitButton.layer.cornerRadius = 3.0
        
        commentBox.delegate = self
        
        //Sets the height of the row to fit text boxes
        commentsTable.estimatedRowHeight = self.commentsTable.rowHeight
        commentsTable.rowHeight = UITableViewAutomaticDimension

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Gets rid of keyboard when somewhere else in container is tapped (note a separate version for the area outside the container in ViewController
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    //Action for when a comment is submitted
    @IBAction func submitPressed(sender: AnyObject) {
        
        if commentBox.text != "" {
            
            //Inserts comments at the beginning of the array to preserve chronological order with newest at the top
            comments.insert(commentBox.text, atIndex: 0)
            
            //Gets the time in a nice format
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
        
        //Uses prototype cell from Interface Builder called "CommentTableCell"
        let tableCell = tableView.dequeueReusableCellWithIdentifier("CommentTableCell", forIndexPath: indexPath) as! CommentTableCell
        tableCell.userInteractionEnabled = true
        tableCell.selectionStyle = .None
        //Sets the text for the cells in the comment table
        tableCell.commentText.text = comments[indexPath.row]
        tableCell.timeLabel.text = commentTimes[indexPath.row]
        
        return tableCell
        
    }
    
    
    //As many rows in the table as there are comments
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }
    
    //Allows the user to delete comments
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            comments.removeAtIndex(indexPath.row)
            commentsTable.deleteRowsAtIndexPaths([indexPath],  withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }
    
    //Closes the keyboard when the return "Done" key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
