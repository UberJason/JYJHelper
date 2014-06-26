//
//  JYJFlightsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsTableViewController: JYJAbstractPageContentViewController {
    
    @lazy var trips: Trip[] = {
        var managedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
        var request = NSFetchRequest(entityName: "Trip");
        return managedObjectContext.executeFetchRequest(request, error: nil) as Trip[];
        }();
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        self.pageIndex = 1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName:"JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated);
//        var flight: Flight = self.trips[0].flights[0] as Flight;
//        
//        var formatter = NSDateFormatter();
//        
//        formatter.dateFormat = "h:mm a";
//        println(flight.departureTime.description);
    }
    
    // #pragma mark - Table view data source
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String {
        return (self.trips[section] as Trip).name;
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.trips.count;
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var trip = self.trips[section];
        return trip.flights.count;
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "flightCell";
        
        var cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as JYJFlightTableViewCell;
        
        var trip = self.trips[indexPath.section];
        var flight: Flight = trip.flights[indexPath.row] as Flight;
        
        var formatter = NSDateFormatter();
        formatter.dateStyle = NSDateFormatterStyle.LongStyle;
        formatter.timeZone = NSTimeZone(name: flight.storedTimeZone);
        
        cell.flightLabel.text = "\(flight.airlineCode) \(flight.flightNumber)";
        cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
        cell.airportsLabel.text = "\(flight.originAirportCode) to \(flight.destinationAirportCode)";
        
        formatter.dateFormat = "h:mm a";
        cell.departureTimeLabel.text = formatter.stringFromDate(flight.departureTime);
        cell.arrivalTimeLabel.text = formatter.stringFromDate(flight.arrivalTime);
        
        return cell;
    }
    
}
