//
//  SummaryViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import Foundation
import UIKit

class SummaryViewController: UIViewController, UIScrollViewDelegate {
    
    var emailSubject:String?
    var emailContent:String?
    var emailContentwCode:String?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var serviceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets abbreviation of service
        var checkedServiceAbbr : String = {
            if checkedService == "Communication Facilitator (CF)" {
                return "CF"
            } else {
                return "SSP"
            }
            }()
        
        //Formats all the text needed for the email and the display on the page:
        emailSubject = "\(user) served \(client) as a \(checkedServiceAbbr) on \(dateString)"
        
        var commentsFormatted: String = {
            if comments.count == 0 {
                return ""
            } else {
                var commentsPlusDates: String = ""
                for (var i = 0; i < comments.count; i++) {
                    commentsPlusDates += "\n- \(commentTimes[i]): \"\(comments[i])\""
                }
                return "Comments:" + commentsPlusDates + "\n\n"
            }
            }()
        emailContent = "\(commentsFormatted)Date: \(dateString) \nStart Time: \(startTime) \nEnd Time: \(endTime) \nTotal Time: \(timeTotal) \n\nService: \(checkedService) \nProvider: \(user) \nClient: \(client)"
        
        emailContentwCode = "\(emailContent) \nClient Code: \(clientCode)\n__\n\nThis is your digital record of services provided through DBSC. If you don't believe you should have recieved this email, or you find something inaccurate in the content, please email us (the Deaf-Blind Service Center) immediately at " //Fill in with email for DBSC
        
        var serviceTextViewText:String = "Record of service preview:\n" + emailContent!
        
        //Using attributedString allows the use of bold lettering for the first line.
        var attributedText: NSMutableAttributedString = NSMutableAttributedString(string:serviceTextViewText)
        
        //Sets the font size to 14 for the rest of the string since the attibutedText of a textview has a smaller font size.
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], range: NSRange(location: 0, length: attributedText.length))
        
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(14)], range: NSRange(location: 0, length: 26))
        
        serviceTextView.attributedText = attributedText

        //Lays out complete service button
        processButton.layer.borderWidth = 0.75
        processButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        processButton.layer.cornerRadius = 3.0
        
        //Hides back button since the service has now been finalized
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Layout for the service text view
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        serviceTextView.layer.cornerRadius = 6
        serviceTextView.layer.borderWidth = 0.5
        serviceTextView.layer.borderColor = borderColor.CGColor
        serviceTextView.textContainer.lineFragmentPadding = 0
        serviceTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    //scrollView has to be set up here rather than in viewDidLoad since here the dimensions of the subviews have surely been set up so the height calculations work out
    override func viewDidLayoutSubviews() {

        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, serviceTextView.frame.size.height + 70)
        
    }
    
    //Sends the user back to the Main Menu after the service has been completed
    @IBAction func backPressed(sender: AnyObject) {
        
        comments = []
        
        //Checks whether connected to the internet. If true, send emails. If not, store them.
        if Reachability.isConnectedToNetwork() == true {
            
            println("Internet connection OK")
            
            var allSent:Bool = false
            
            var alert = UIAlertController()
            
            if EmailSend.sendEmail(userEmail, subject: emailSubject!, content: "Hello from DBSC,\n\n" + emailContent!) && EmailSend.sendEmail(clientEmail, subject: emailSubject!, content: "Hello from DBSC,\n\n" + emailContent!) && EmailSend.sendEmail(dbscEmail, subject: emailSubject!, content: emailContentwCode!) {
                
                allSent = true
                
                //Alert to end and notify of email
                alert = UIAlertController(title: "Service Processed!", message: "An email has been sent to you and your client", preferredStyle: UIAlertControllerStyle.Alert)
                
            } else {
                
                alert = UIAlertController(title: "Storing information for later", message: "Unsteady internet access. Please run the app again when access is reliable to automatically process this service", preferredStyle: UIAlertControllerStyle.Alert)
                
            }
            
            EmailSend.storeEmail(userEmail, clientEmail: clientEmail, subject: emailSubject!, content: emailContent!, contentwCode: emailContentwCode!, sent: allSent)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
                
                self.performSegueWithIdentifier("backToMain", sender: self)
                
            }))
            
            self.presentViewController(alert, animated:true, completion:nil)
            
        } else {
            
            println("Internet connection FAILED")
            
            EmailSend.storeEmail(userEmail, clientEmail: clientEmail, subject: self.emailSubject!, content: self.emailContent!, contentwCode: self.emailContentwCode!, sent: false)
            
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
