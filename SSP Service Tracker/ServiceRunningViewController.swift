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

class ServiceRunningViewController: UIViewController {

    var timer = NSTimer()
    
    var seconds:Int = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    
    @IBAction func completePressed(sender: AnyObject) {
        
        scanNumber = "Second"
        
        //Asks the user if they're sure to prevent any accidental completions
        var alert = UIAlertController(title: "Service Completed?", message: "Press \"Yes\" to continue and send email to DBSC", preferredStyle: UIAlertControllerStyle.Alert)
        
        //The alert has two choices, "Yes" and "No"
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            
            self.performSegueWithIdentifier("serviceCompleted", sender: self)
            
            timeTotal = self.timeLabel.text!
            
            self.timer.invalidate()
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action) -> Void in
            
        }))
        
        //Presents the alert
        self.presentViewController(alert, animated:true, completion:nil)
    }

    override func viewWillAppear(animated: Bool) {
        
        //Sets labels to match the current service client and provider
        toLabel.text = "Providing to: " + "\(QRInfo[0])"
        byLabel.text = "Provided by: " + "\(user)"
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
