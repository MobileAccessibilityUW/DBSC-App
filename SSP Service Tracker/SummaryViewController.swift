//
//  SummaryViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import Foundation
import UIKit

class SummaryViewController: UIViewController {
    

    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesLabel.sizeToFit()
        
        //Sets text labels to match client and provider
        toLabel.text = "Client: \(client)"
        byLabel.text = "Provider: \(user)"
        servicesLabel.text = "Service provided: " + checkedService
        
        //Hides back button since the service has now been finalized
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        totalTimeLabel.text = "Total Time: \(timeTotal)"
        
        //Lays out complete service button
        processButton.layer.borderWidth = 0.75
        processButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        processButton.layer.cornerRadius = 3.0
        
    }
    
    //Sends the user back to the Main Menu after the service has been completed
    @IBAction func backPressed(sender: AnyObject) {
        
        var checkedServiceAbbr : String = {
            if checkedService == "Communication Facilitator (CF)" {
                return "CF"
            } else {
                return "SSP"
            }
        }()
        
        var emailSubject:String = "\(user) served \(client) as a \(checkedServiceAbbr)"
        
        var commentsFormatted: String = {
            var commentsPlusDates: String = ""
            for (var i = 0; i < comments.count; i++) {
                commentsPlusDates += "\n-\"\(comments[i])\" at \(commentTimes[i])"
            }
            return commentsPlusDates
            }()
        
        var emailContent:String = "Hello from DBSC,\n\n Comments: \(commentsFormatted) \n\nDate: \(dateString) \nStart Time: \(startTime) \nEnd Time: \(endTime) \nTotal Time: \(timeTotal) \n\nService: \(checkedService) \nProvider: \(user) \nClient: \(client)"
        
        var emailContentwCode:String = "\(emailContent) \nClient Code: \(clientCode)\n__\n\nThis is your digital record of services provided through DBSC. If you don't believe you should have recieved this email, or you find something inaccurate in the content, please email us (the Deaf-Blind Service Center) immediately at " //Fill in with email for DBSC
        
        //Checks whether connected to the internet. If true, send emails. If not, store them.
        
        if Reachability.isConnectedToNetwork() == true {
            
            println("Internet connection OK")
            
            EmailSend.sendEmail(userEmail, subject: emailSubject, content: emailContentwCode)
            EmailSend.sendEmail(clientEmail, subject: emailSubject, content: emailContent)
            //EmailSend.sendEmail("harguscj@whitman.edu", subject: emailSubject, content: emailContent)
            
            //Alert to end and notify of email
            var alert = UIAlertController(title: "Service Processed!", message: "An email has been sent to you and your client", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
                
                self.performSegueWithIdentifier("backToMain", sender: self)
                
            }))
            
            self.presentViewController(alert, animated:true, completion:nil)
            
        } else {
            
            println("Internet connection FAILED")
            
            EmailSend.storeEmail(userEmail, subject: emailSubject, content: emailContentwCode)
            EmailSend.storeEmail(clientEmail, subject: emailSubject, content: emailContent)
            //EmailSend.storeEmail(userEmail, subject: emailSubject, content: emailContent)
            
            //Alert to describe what to do when internet access is regained
            var alert = UIAlertController(title: "Storing information for when internet access returns", message: "No internet access. Please run app again when access is restored to automatically process this service", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
                
                self.performSegueWithIdentifier("backToMain", sender: self)
                
            }))
            
            self.presentViewController(alert, animated:true, completion:nil)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
