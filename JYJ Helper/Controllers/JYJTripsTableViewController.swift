//
//  JYJTripsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJTripsTableViewController: JYJAbstractPageContentViewController {

    @lazy var myTrips: Trip[] = {
        var managedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
        var fetchRequest = NSFetchRequest(entityName: "Trip");
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as Trip[];
    }();
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }

    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        self.pageIndex = 0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.registerNib(UINib(nibName: "JYJTripTableViewCell", bundle: nil), forCellReuseIdentifier: "tripCell");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return "My Trips";
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 88;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1;
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.myTrips.count;
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        var cellIdentifier = "tripCell";
        
        var cell: JYJTripTableViewCell = tableView!.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as JYJTripTableViewCell;

        let formatter = NSDateFormatter();
        formatter.dateFormat = "MMMM d";
        let trip = self.myTrips[indexPath.row];
        
        cell.nameLabel.text = trip.name;
        cell.startDateLabel.text = formatter.stringFromDate(trip.startDate);
        cell.endDateLabel.text = formatter.stringFromDate(trip.endDate);
        // Configure the cell...

        return cell;
    }

}
