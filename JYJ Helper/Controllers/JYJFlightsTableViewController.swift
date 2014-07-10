//
//  JYJFlightsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var navigationBar: UINavigationBar
    @IBOutlet var tableView: UITableView
    var trip: Trip!;
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad");
    
        self.tableView.registerNib(UINib(nibName:"JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.title = self.trip.name;
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated);
//        println("viewDidAppear");
//        var flight: Flight = self.trips[0].flights[0] as Flight;
//        
//        var formatter = NSDateFormatter();
//        
//        formatter.dateFormat = "h:mm a";
//        println(flight.departureTime.description);
//    }
    
    // #pragma mark - Table view data source
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String {
        return "Flights";
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.trip.flights.count;
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "flightCell";
        
        var cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as JYJFlightTableViewCell;
        
        var flight: Flight = self.trip.flights[indexPath.row] as Flight;
        
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
