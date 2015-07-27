//
//  SettingsViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    //Saves settings
    @IBAction func savePressed(sender: AnyObject) {
        
        if user != nameLabel.text {
            
            user = nameLabel.text
            
            NSUserDefaults.standardUserDefaults().setObject(nameLabel.text, forKey: "userName")
            
            
        }
        
        if userEmail != emailLabel.text {
            
            userEmail = emailLabel.text
            
            NSUserDefaults.standardUserDefaults().setObject(emailLabel.text, forKey: "userEmail")
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    //Closes keyboard when screen is touched outside of keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lays out save information button
        saveButton.layer.borderWidth = 0.75
        saveButton.layer.borderColor = UIColor(red: 0, green: 0.478431 , blue: 1.0, alpha: 1.0).CGColor
        saveButton.layer.cornerRadius = 3.0
        
        if user != "" {
            nameLabel.text = user
        }
        if userEmail != "" {
            emailLabel.text = userEmail
        }
        
        //navigationController?.prompt = "Please edit your information here"
        
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
