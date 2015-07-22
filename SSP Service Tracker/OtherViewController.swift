//
//  OtherViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

//This class is responsible for the comment section which appears in multiple places in a container view
class OtherViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        commentsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gives the container for the comment section a border
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        self.view.layer.borderWidth = 0.5
        self.view.layer.borderColor = borderColor.CGColor
        self.view.layer.cornerRadius = 5.0
        
        //Border for the comment box
        commentBox.layer.borderWidth = 0.5
        commentBox.layer.borderColor = borderColor.CGColor
        commentBox.layer.cornerRadius = 1.0
        
        //Gets rid of the line between comment cells
        commentsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        submitButton.layer.cornerRadius = 3.0
        
        self.commentBox.delegate = self

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
    
    /*
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Uses prototype cell from Interface Builder called "CommentTableCell"
        let tableCell = tableView.dequeueReusableCellWithIdentifier("CommentTableCell", forIndexPath: indexPath) as! CommentTableCell
        
        //Sets the text for the cells in the comment table
        tableCell.commentText.text = comments[indexPath.row]
        tableCell.timeLabel.text = commentTimes[indexPath.row]
        
        return tableCell
        
    }
    
    //As many rows in the table as there are comments
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
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
