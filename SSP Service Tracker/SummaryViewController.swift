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

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    
    //Sends the user back to the Main Menu after the service has been completed
    @IBAction func backPressed(sender: AnyObject) {
        performSegueWithIdentifier("backToMain", sender: self)
        scanNumber == "First"
        
        var mail = SKPSMTPMessage()
        mail.fromEmail = "dbscemailer@gmail.com"
        mail.toEmail = "harguscj@whitman.edu"
        mail.requiresAuth = true
        mail.login = "dbscemailer@gmail.com"
        mail.pass = "t4dc1ICPsS"
        mail.subject = "\(user) served \(QRInfo[0]) as an \(checkedService)"
        
        mail.wantsSecure = true
        mail.relayHost = "smtp.gmail.com"
        
        mail.relayPorts = [587]
        
        var commentsFormatted: String = "\n-".join(comments)
        var parts: NSDictionary = [
            "kSKPSMTPPartContentTypeKey": "text/plain; charset=UTF-8",
            "kSKPSMTPPartMessageKey": "Comments: \n-\(commentsFormatted)",
        ]
        
        mail.parts = [parts]
        
        mail.send()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets text labels to match client and provider
        toLabel.text = "Provided to: " + "\(QRInfo[0])"
        byLabel.text = "Provided by: " + "\(user)"
        servicesLabel.text = "Service provided: " + checkedService
        
        //Hides back button since the service has now been finalized
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        totalTimeLabel.text = "Total Time: " + "\(timeTotal)"
        
        
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
