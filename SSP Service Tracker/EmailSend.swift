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
        mail.pass = dbscEmailPass
        
        mail.subject = subject
        mail.wantsSecure = true
        mail.relayHost = "smtp.gmail.com"
        
        mail.relayPorts = [587]
        mail.parts = [parts]
        mail.toEmail = sendTo
        
        //Sends email as a synchronous task
        var sentBool:Bool = false
        dispatch_sync(dispatch_get_global_queue(
            Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                
                if mail.send() == true {
                    sentBool = true
                }
        }
        
        return sentBool
    }
    
    class func formatComments() -> String {
        
        if comments.count == 0 {
            return ""
        } else {
            var commentsPlusDates: String = ""
            for (var i = 0; i < comments.count; i++) {
                commentsPlusDates += "\n- \(commentTimes[i]): \"\(comments[i])\""
            }
            return "Comments:" + commentsPlusDates + "\n\n"
        }
        
    }
    
    //Stores the email in core data for "Email" entity
    class func storeEmail() {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        //Sets abbreviation of service
        checkedServiceAbbr = {
            if checkedService == "Communication Facilitator (CF)" {
                return "CF"
            } else {
                return "SSP"
            }
            }()
        
        //Formats all the text needed for the email and the display on the page:
        var subject = "\(user) served \(client) as a \(checkedServiceAbbr) on \(dateString)"
        
        var commentsFormatted: String = EmailSend.formatComments()
        
        var content = "\(commentsFormatted)Date: \(dateString) \nStart Time: \(startTime) \nEnd Time: \(endTime) \nTotal Time: \(timeTotal) \n\nService: \(checkedService) \n\(checkedServiceAbbr): \(user) \nClient: \(client)"
        
        var contentwCode = "\(content) \nClient Code: \(clientCode)\n__\n\nThis is your digital record of services provided through DBSC. If you don't believe you should have recieved this email, or you find something inaccurate in the content, please email us (the Deaf-Blind Service Center) immediately at " //Fill in with email for DBSC
        
        storedEmail = NSEntityDescription.insertNewObjectForEntityForName("Email", inManagedObjectContext: context) as? NSManagedObject
        storedEmail?.setValue(clientEmail, forKey: "userEmail")
        storedEmail?.setValue(userEmail, forKey: "clientEmail")
        storedEmail?.setValue(subject, forKey: "subject")
        storedEmail?.setValue(content, forKey: "content")
        storedEmail?.setValue(contentwCode, forKey: "contentwCode")
        storedEmail?.setValue(false, forKey: "sent")
        storedEmail?.setValue(false, forKey: "finished")
        storedEmail?.setValue(NSDate(), forKey: "date")
        
        //Saves context, throws error if there's a problem
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func updateEmail (sent: Bool) {
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var commentsFormatted: String = EmailSend.formatComments()
        
        var content = "\(commentsFormatted)Date: \(dateString) \nStart Time: \(startTime) \nEnd Time: \(endTime) \nTotal Time: \(timeTotal) \n\nService: \(checkedService) \n\(checkedServiceAbbr): \(user) \nClient: \(client)"
        
        var contentwCode = "\(content) \nClient Code: \(clientCode)\n__\n\nThis is your digital record of services provided through DBSC. If you don't believe you should have recieved this email, or you find something inaccurate in the content, please email us (the Deaf-Blind Service Center) immediately at " //Fill in with email for DBSC
        
        storedEmail?.setValue(content, forKey: "content")
        storedEmail?.setValue(contentwCode, forKey: "contentwCode")
        storedEmail?.setValue(sent, forKey: "sent")
        
        //Saves context, throws error if there's a problem
        var error: NSError?
        if !context.save(&error) {
            println("Could not update: \(error), \(error?.userInfo)")
        }
    }
}

