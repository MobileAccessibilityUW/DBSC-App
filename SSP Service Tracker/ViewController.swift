//
//  ViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/6/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit
import CoreData

var user:String = ""
var userEmail:String = ""
var QRInfo:[String] = [""]
var client:String = ""
var clientCode:String = "No ID Card Scanned"
var clientEmail:String = ""
var checkedService:String = ""
var scanNumber:String = "First"
var comments:[String] = ["Nevermind they found it.", "My client can't find their ID card, I think I'll go ahead and press lost ID so that we can move forward.", "They were late by 10 minutes."]
var commentTimes:[String] = ["3:46 PM", "3:43 PM", "2:10 PM"]

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //Service choices for the provider
    var services: [String] = ["Communication Facilitator (CF)", "Service Support Program (SSP)"]
    
    @IBOutlet weak var servicesTableView: UITableView!
    
    @IBOutlet weak var beginServiceButton: UIButton!
    
    //Start button pressed
    @IBAction func verifyPressed(sender: AnyObject) {
        
        if checkedService == "" {
            errorLabel.alpha = 1
        } else {
            performSegueWithIdentifier("takeQRShot", sender: self)
        }
    }
    
    //Allows user to continue by pressing "Missing ID?" and entering their client's name
    @IBAction func lostIDPressed(sender: AnyObject) {
        
        var inputTextField: UITextField?
        
        var alert = UIAlertController(title: "Missing Client ID Card?", message: "Please enter your client's name and press \"Continue\" if so", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            inputTextField = textField
            inputTextField!.placeholder = "Enter client name here"
            
        })
        
        alert.addAction(UIAlertAction(title: "Back", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alert) -> Void in
            
            client = inputTextField!.text
            self.performSegueWithIdentifier("lostIDSkip", sender: self)
            
        }))
        
        self.presentViewController(alert, animated:true, completion:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Resets checked service when page is reloaded
        checkedService = ""
        
        //self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 1.0, alpha: 1)
        
        //Gets rid of the line between comment cells
        servicesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        servicesTableView.rowHeight = 32
        
        //Registers the default "cell"
        servicesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //Use core data to get user and user email address
        if let storedName:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userName") {
            
            user = storedName as! String
        }
        if let storedEmail:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userEmail") {
                
            userEmail = storedEmail as! String
        }
        
        //Lays out begin service button
        beginServiceButton.layer.borderWidth = 0.75
        beginServiceButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        beginServiceButton.layer.cornerRadius = 3.0
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            var context:NSManagedObjectContext = appDel.managedObjectContext!
            
            var request = NSFetchRequest(entityName: "Email")
            
            request.returnsObjectsAsFaults = false
            
            var emails = context.executeFetchRequest(request, error: nil)
            
            println(emails)
            
            if(emails?.count > 0) {
                
                for email: AnyObject in emails! {
                    
                    if let toEmail = email.valueForKey("toEmail") as? String {
                        
                        if let subject = email.valueForKey("subject") as? String {
                            
                            if let content = email.valueForKey("content") as? String {
                                
                                EmailSend.sendEmail(toEmail, subject: subject, content: content)
                                
                                context.deleteObject(email as! NSManagedObject)
                            }
                        }
                    }
                    context.save(nil)
                }
                
                var alert = UIAlertController(title: "Past services processed", message: "Past services performed without internet access have now been processed with DBSC", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated:true, completion:nil)
                
            } else {
                
                println("No results")
            }
        }
    }
    
    //Closes keyboard when touched outside
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.services.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Sets up the service choices table
        let tableCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        tableCell.textLabel!.text = self.services[indexPath.row]
        
        return tableCell
    }
    
    //Gives the cell a checkmark and sets it as the checkedService when tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        errorLabel.alpha = 0
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        checkedService = self.services[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
    }
    
    //Unchecks the checked cell when another cell is tapped
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        var otherCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        otherCell.accessoryType = UITableViewCellAccessoryType.None
    }


}

