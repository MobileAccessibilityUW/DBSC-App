//
//  SummaryViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import Foundation
import UIKit

var subject: String = ""
var content: String = ""
var contentwCode: String = ""

class SummaryViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var serviceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailSend.updateEmail(false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:",name:"load", object: nil)
    
        updateTextView()

        //Lays out complete service button
        processButton.layer.borderWidth = 0.75
        processButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        processButton.layer.cornerRadius = 3.0
        
        //Hides back button since the service has now been finalized
        //self.navigationItem.setHidesBackButton(true, animated: true)
        
        //Layout for the service text view
        var borderColor : UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        serviceTextView.layer.cornerRadius = 3
        serviceTextView.layer.borderWidth = 0.5
        serviceTextView.layer.borderColor = borderColor.CGColor
        serviceTextView.textContainer.lineFragmentPadding = 0
        serviceTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
    }

    func reload(notification: NSNotification){
        //load data here
        updateTextView()
    }

    //scrollView has to be set up here rather than in viewDidLoad since here the dimensions of the subviews have surely been set up so the height calculations work out
    override func viewDidLayoutSubviews() {

        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, serviceTextView.frame.size.height + 370)
        
    }
    
    func updateTextView() {
        
        content = storedEmail?.valueForKey("content") as! String
        contentwCode = storedEmail?.valueForKey("contentwCode") as! String
        subject = storedEmail?.valueForKey("subject") as! String
        
        var serviceTextViewText:String = content
        
        //Using attributedString allows the use of bold lettering for the first line.
        var attributedText: NSMutableAttributedString = NSMutableAttributedString(string:serviceTextViewText)
        
        //Sets the font size to 14 for the rest of the string since the attibutedText of a textview has a smaller font size.
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14)], range: NSRange(location: 0, length: attributedText.length))
        
        attributedText.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(14)], range: NSRange(location: 0, length: 26))
        
        serviceTextView.text = content
        
    }
    
    //Sends the user back to the Main Menu after the service has been completed
    @IBAction func backPressed(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Process service and return to main menu?", message: "If you have any comments you'd like to add or delete, press \"Not Yet\"", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Not Yet", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Proceed", style: .Default, handler: { (action) -> Void in
            
            startDate = nil
            seconds = 0
            scanNumber = "First"
            comments = []
            storedEmail!.setValue(true, forKey: "finished")
            
            
            //Checks whether connected to the internet. If true, send emails. If not, store them.
            if Reachability.isConnectedToNetwork() == true {
                
                println("Internet connection OK")
                
                if EmailSend.sendEmail(userEmail, subject: subject, content: "Hello from DBSC,\n\n" + content) && EmailSend.sendEmail(clientEmail, subject: subject, content: "Hello from DBSC,\n\n" + content) && EmailSend.sendEmail(dbscEmail, subject: subject, content: contentwCode) {
                    
                    storedEmail!.setValue(true, forKey: "sent")
                    
                    //Alert to end and notify of email
                    alert = UIAlertController(title: "Service processed!", message: "An email has been sent to you and your client.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                } else {
                    
                    alert = UIAlertController(title: "Storing information for later", message: "Unsteady internet access. Please run the app again when access is reliable to automatically process this service.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                }
                
                storedEmail = nil
                
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
                    
                    
                    self.performSegueWithIdentifier("backToMain", sender: self)
                    
                }))
                
                self.presentViewController(alert, animated:true, completion:nil)
                
                
                
            } else {
                
                println("Internet connection FAILED")
                
                storedEmail = nil
                
                //Alert to describe what to do when internet access is regained
                var alert = UIAlertController(title: "Storing information for when internet access returns", message: "No internet access. Please run app again when access is restored to automatically process this service.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (action) -> Void in
                    
                    
                    self.performSegueWithIdentifier("backToMain", sender: self)
                    
                }))
                
                self.presentViewController(alert, animated:true, completion:nil)
                
                EmailSend.updateEmail(false)
                
            }

            
        }))
        
        self.presentViewController(alert, animated:true, completion:nil)
        
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
