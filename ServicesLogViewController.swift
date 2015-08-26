//
//  ServicesLogViewController.swift
//  SSP Service Tracker
//
//  Created by Connor Hargus on 7/28/15.
//  Copyright (c) 2015 AppMaker. All rights reserved.
//

import UIKit
import CoreData

class ServicesLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var pastServicesTable: UITableView!
    
    var services: [(String, String, Bool)] = []
    var filteredServices: [(String, String, Bool)] = []
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        services = []
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Email")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        request.returnsObjectsAsFaults = false
        
        var emails = context.executeFetchRequest(request, error: nil)
        
        if(emails?.count > 0) {
            
            for email:AnyObject in emails! {
                
                let email = email as? NSManagedObject
                
                EmailFunctions.updateGlobalVariables(email)
                
                services.append(EmailFunctions.formatContent("inapp", email: email!), EmailFunctions.formatSubject(email!), email!.valueForKey("sent") as! Bool)
            }
        }
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search by keyword, name, etc."
            controller.searchBar.barTintColor = UIColor(red: 224/256, green: 244/256, blue: 255/256, alpha: 1)
            controller.searchBar.delegate = self
            
            self.pastServicesTable.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        pastServicesTable.estimatedRowHeight = self.pastServicesTable.rowHeight
        pastServicesTable.rowHeight = UITableViewAutomaticDimension
        
        //Gets rid of the line between comment cells
        pastServicesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        pastServicesTable.reloadData()
        
        self.updateSearchResultsForSearchController(resultSearchController)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        pastServicesTable.reloadData()
    }
    
    // MARK - Helpers methods
    func filterContentForSearchText(searchText: String) {
        self.filteredServices = self.services.filter({(service:(String,String,Bool)) -> Bool in
            
            let subjectMatch = service.1.uppercaseString.rangeOfString(searchText.uppercaseString)
            let contentMatch = service.0.uppercaseString.rangeOfString(searchText.uppercaseString)
            return (subjectMatch != nil) || (contentMatch != nil)
        })
    }
    
    // MARK: - UISearchControllerDelegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredServices = services
        pastServicesTable.separatorStyle = UITableViewCellSeparatorStyle.None
        filterContentForSearchText(searchController.searchBar.text)
        pastServicesTable.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Uses prototype cell from Interface Builder called "CommentTableCell"
        let tableCell = tableView.dequeueReusableCellWithIdentifier("serviceCell", forIndexPath: indexPath) as! PastServiceCell
        tableCell.userInteractionEnabled = true
        tableCell.selectionStyle = .None
        
        //Sets the text for the cells in the comment table
        if services.count == 0 {
            
            tableCell.serviceTextView.alpha = 0
            tableCell.serviceTitleView.text = "No past services recorded."
        }
        else {
            if services.count >= 2 {
                pastServicesTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            }
        
            let service:(String,String,Bool)
            
            //Displays different table if searching is active
            if (self.resultSearchController.active) {
                service = self.filteredServices[indexPath.row]
            } else {
                service = self.services[indexPath.row]
            }
            tableCell.serviceTextView.text = service.0
            tableCell.serviceTitleView.text = service.1
            if services[indexPath.row].2 == true {
                
                tableCell.sentTextView.alpha = 1
            }
        }
        return tableCell
    }
    
    //Sets inset for the separator between cells
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30)
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(0, 30, 0, 30)
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    //As many rows in the table as there are services, depending on searching or not.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.active) {
            return filteredServices.count
        } else {
            return max(1, services.count)
        }
    }
    
    
    //Closes the keyboard when the return "Search" key is pressed
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Closes keyboard on outside touch
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
}

