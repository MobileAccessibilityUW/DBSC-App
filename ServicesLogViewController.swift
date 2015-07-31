//
//  ServicesLogViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/28/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit
import CoreData

class ServicesLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pastServicesTable: UITableView!
    
    override func viewDidLoad() {
        
        pastServicesTable.estimatedRowHeight = self.pastServicesTable.rowHeight
        pastServicesTable.rowHeight = UITableViewAutomaticDimension
        
        //Gets rid of the line between comment cells
        pastServicesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        pastServicesTable.backgroundView = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Email")
        
        request.returnsObjectsAsFaults = false
        
        //request.predicate = NSPredicate(format: "sent = %@", false)
        
        var emails = context.executeFetchRequest(request, error: nil)
        
        if(emails?.count > 0) {
            
            emails = reverse(emails!)
            
            for email:AnyObject in emails! {
            
                services.append(email.valueForKey("content") as! String, email.valueForKey("subject") as! String)
            }
        }
        
        //println(emails)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Uses prototype cell from Interface Builder called "CommentTableCell"
        let tableCell = tableView.dequeueReusableCellWithIdentifier("serviceCell", forIndexPath: indexPath) as! PastServiceCell
        tableCell.userInteractionEnabled = true
        tableCell.selectionStyle = .None
        //Sets the text for the cells in the comment table
        tableCell.serviceTextView.text = services[indexPath.row].0
        tableCell.serviceTitleView.text = services[indexPath.row].1
        return tableCell
        
    }
    
    
    //As many rows in the table as there are comments
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return services.count
        
    }
    
    //Allows the user to delete comments
    /*func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            comments.removeAtIndex(indexPath.row)
            pastServicesTable.deleteRowsAtIndexPaths([indexPath],  withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
    }*/
    
    //Closes the keyboard when the return "Done" key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
}

