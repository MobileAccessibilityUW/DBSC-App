//
//  ServiceRunningViewController.swift
//  
//
//  Created by Connor Hargus on 7/6/15.
//
//

import UIKit

import Foundation

var timeTotal:String = ""
var startTime:String = ""
var startDate:NSDate?
var endTime:String = ""
var dateString:String = ""
var seconds:Int = 0

class ServiceRunningViewController: UIViewController {

    var timer = NSTimer()
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up back button for the next view
        var button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "backPressed")
        self.navigationItem.leftBarButtonItem = button
        
        //Lays out complete service button
        completeButton.layer.borderWidth = 0.75
        completeButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        completeButton.layer.cornerRadius = 3.0
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //Sets the start time as view appears
        let date = NSDate()
        startDate = date
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        startTime = formatter.stringFromDate(date)
        
        //Sets the date at beginning of service
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateString = dateFormatter.stringFromDate(date)
        toLabel.text = "Client: " + "\(client)"
        byLabel.text = "Provider: " + "\(user)"
        
        timer.invalidate()
        
        //Sets timer to start counting and calling "changeLabel"
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeLabel", userInfo: nil, repeats: true)
    }
    
    //Updates the time label as the timer is running
    func changeLabel() {
        
        seconds++
        
        var hh = String(format: "%02d", seconds / 3600)
        var mm = String(format: "%02d", (seconds % 3600) / 60)
        var ss = String(format: "%02d", (seconds % 3600) % 60)
        timeLabel.text = hh + ":" + mm + ":" + ss
    }
    
    
    //Reverts back to first QR code scan, asks if they're sure
    func backPressed() {
        scanNumber = "First"
        
        let cancelMenu = UIAlertController(title: nil, message: "Are you sure you want to cancel this service? Any work thus far will not be saved", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel Service", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            startDate = nil
            seconds = 0
            self.performSegueWithIdentifier("cancelService", sender: self)
        })
        
        let nevermindAction = UIAlertAction(title: "Oops, return to service", style: .Cancel, handler: nil)
        
        cancelMenu.addAction(cancelAction)
        cancelMenu.addAction(nevermindAction)
        
        self.presentViewController(cancelMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func completePressed(sender: AnyObject) {
        
        scanNumber = "Second"
        
        //Sets the end time when complete is pressed
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        endTime = formatter.stringFromDate(date)
        
        self.performSegueWithIdentifier("serviceCompleted", sender: self)
        
        timeTotal = self.timeLabel.text!
        
        self.timer.invalidate()
    }
    
    //Sets up what happens if no ID is found
    @IBAction func lostIDPressed(sender: AnyObject) {
        
        var inputTextField: UITextField?
        
        var alert = UIAlertController(title: "Missing Client ID Card?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        if client == "" {
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                inputTextField = textField
                inputTextField!.placeholder = "Enter client name here"
                
            })
        }
        
        alert.addAction(UIAlertAction(title: "Back", style: .Default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (alert) -> Void in
            if client == "" {
                client = inputTextField!.text
            }
            self.performSegueWithIdentifier("lostIDSecondSkip", sender: self)
            
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
