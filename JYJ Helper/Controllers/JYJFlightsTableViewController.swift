//
//  JYJFlightsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit
import QuartzCore

class JYJFlightsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddEditTripDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var trip: Trip!;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad");
        
        self.tableView.registerNib(UINib(nibName:"JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
        self.tableView.registerNib(UINib(nibName: "JYJTripTableViewCell", bundle: nil), forCellReuseIdentifier: "tripCell");
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.title = self.trip.name;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        print("viewDidAppear");
    }
    
    // #pragma mark - Table view data source
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Trip Details" : "Flights";
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 0 ? 1 : self.trip.flights.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = self.identifierForRowAtIndexPath(indexPath);
        
        if(cellIdentifier == "tripCell") {
            let cell: JYJTripTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! JYJTripTableViewCell;
            let formatter = NSDateFormatter();
            formatter.dateFormat = "MMMM d";
            if(trip.storedTimeZone != nil) {
                formatter.timeZone = NSTimeZone(name: trip.storedTimeZone);
            }
            
            cell.nameLabel.text = trip.name;
            cell.startDateLabel.text = formatter.stringFromDate(trip.startDate);
            cell.endDateLabel.text = formatter.stringFromDate(trip.endDate);
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            
            return cell;
        }
        else {
            let cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! JYJFlightTableViewCell;
            
            let flight: Flight = self.trip.flights[indexPath.row] as! Flight;
            
            let formatter = NSDateFormatter();
            formatter.dateStyle = NSDateFormatterStyle.LongStyle;
            if(flight.storedTimeZone != nil) {
                formatter.timeZone = NSTimeZone(name: flight.storedTimeZone);
            }
            
            cell.flightLabel.text = "\(flight.airlineCode) \(flight.flightNumber)";
            cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
            cell.airportsLabel.text = "\(flight.originAirportCode) to \(flight.destinationAirportCode)";
            
            formatter.dateFormat = "h:mm a";
            cell.departureTimeLabel.text = formatter.stringFromDate(flight.departureTime);
            cell.arrivalTimeLabel.text = formatter.stringFromDate(flight.arrivalTime);
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None;
            
            return cell;
        }
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        if(indexPath.section == 0) {
            return "tripCell";
        }
        else {
            return "flightCell";
        }
    }
    
    func didFinishCreatingOrEditingATrip() {
        self.dismissViewControllerAnimated(true, completion: nil);
        self.tableView.reloadData();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "editTripSegue") {
            let destinationVC = segue.destinationViewController as! JYJAddEditTripTableViewController;
            destinationVC.trip = self.trip;
            destinationVC.type = TripViewType.Edit;
            destinationVC.delegate = self;
        }
    }
}
