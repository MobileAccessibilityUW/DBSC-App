//
//  ViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/6/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit



var user:String = ""

var other:String = ""

var QRInfo:[String] = [""]

var checkedService:String = ""

var scanNumber:String = "First"

var comments:[String] = ["Nevermind they found it", "My client can't find their ID card, I might go ahead an press lost ID so that we can move forward", "They were late by 10 minutes"]
var commentTimes:[String] = ["3:46 PM", "3:43 PM", "2:10 PM"]

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    //Service choices for the provider
    var services: [String] = ["Communication Facilitator (CF)", "Service Support Program (SSP)"]
    
    @IBOutlet weak var servicesTableView: UITableView!
    
    @IBAction func verifyPressed(sender: AnyObject) {
        
        if checkedService == "" {
            
            errorLabel.alpha = 1
            
        } else {
        
            performSegueWithIdentifier("takeQRShot", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Registers the default "cell"
        servicesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //commentsTableView.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
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

