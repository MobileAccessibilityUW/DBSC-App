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

var comments:[String] = ["Hey DBSC","They were late by 10 minutes"]
var commentTimes:[String] = ["3:43","2:10"]

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var services: [String] = ["Communication Facilitator (CF)", "Service Support Program (SSP)"]
    
    @IBOutlet weak var servicesTableView: UITableView!
    
    @IBAction func verifyPressed(sender: AnyObject) {
        
        if checkedService == "" {
            
            errorLabel.alpha = 1
            
        } else {
        
            performSegueWithIdentifier("takeQRShot", sender: self)
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //commentsTableView.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")

    }
    
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
        
        if tableView == self.servicesTableView {
            
            return self.services.count
            
        } else {
            
            return comments.count
            
        }
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Checks which table we're working with
        if tableView == self.servicesTableView {
            
            let tableCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            
            tableCell.textLabel!.text = self.services[indexPath.row]
            
            return tableCell
            
        } else {
            let commentCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
            
            //commentCell.commentText.text = "Hello DBSC" //comments[indexPath.row]
            //commentCell.timeText.text = "1:40 PM, Jan 16, 2015" //comments[indexPath.row]

            
            return commentCell
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        errorLabel.alpha = 0
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        checkedService = self.services[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        var otherCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        otherCell.accessoryType = UITableViewCellAccessoryType.None
    }


}

