//
//  SummaryViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    
    @IBAction func backPressed(sender: AnyObject) {
        performSegueWithIdentifier("backToMain", sender: self)
        scanNumber == "First"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toLabel.text = "Provided to: " + "\(QRInfo[0])"
        byLabel.text = "Provided by: " + "\(user)"
        servicesLabel.text = "Services provided: " + checkedService
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        totalTimeLabel.text = "Total Time: " + "\(timeTotal)"
        
        // Do any additional setup after loading the view.
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
