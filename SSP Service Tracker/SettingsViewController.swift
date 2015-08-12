//
//  SettingsViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/8/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var savedLabel: UILabel!
    
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
        
        savedLabel.alpha = 1
        
    }
    
    //Removes the "Saved" label when information is edited
    func textFieldDidBeginEditing(textField: UITextField) {
        
        savedLabel.alpha = 0
    }
    
    //Closes the keyboard when the return "Done" key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
        if user != "" && userEmail != "" {
            savedLabel.alpha = 1
        }
        
        //navigationController?.prompt = "Please edit your information here"
        
        nameLabel.delegate = self
        emailLabel.delegate = self
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
