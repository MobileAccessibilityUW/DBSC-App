//
//  EmailSend.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/23/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class EmailSend {
    
    //Sends an email using the SKPSMTPMessage Framework in "eMail Framework" Folder
    class func sendEmail(sendTo:String, subject:String, content: String) -> Bool {
        
        var parts: NSDictionary = [
            "kSKPSMTPPartContentTypeKey": "text/plain; charset=UTF-8",
            "kSKPSMTPPartMessageKey": content
        ]
        
        var mail = SKPSMTPMessage()
        mail.fromEmail = dbscEmail
        mail.requiresAuth = true
        mail.login = dbscEmail
        mail.pass = "t4dc1ICPsS"
        
        mail.subject = subject
        mail.wantsSecure = true
        mail.relayHost = "smtp.gmail.com"
        
        mail.relayPorts = [587]
        mail.parts = [parts]
        mail.toEmail = sendTo
        
        if mail.send() == true {
            return true
        } else {
            return false
        }
        
    }
    
    //Stores the email in core data for "Email" entity
    class func storeEmail(userEmail:String, clientEmail:String, subject:String, content: String, contentwCode:String, sent:Bool) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let newEmail = NSEntityDescription.insertNewObjectForEntityForName("Email", inManagedObjectContext: context) as! NSManagedObject
        
        newEmail.setValue(clientEmail, forKey: "userEmail")
        newEmail.setValue(userEmail, forKey: "clientEmail")
        newEmail.setValue(subject, forKey: "subject")
        newEmail.setValue(content, forKey: "content")
        newEmail.setValue(contentwCode, forKey: "contentwCode")
        newEmail.setValue(sent, forKey: "sent")
        
        
        //Saves context, throws error if there's a problem
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
}
