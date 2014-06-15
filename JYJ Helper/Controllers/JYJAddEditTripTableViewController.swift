//
//  JYJAddEditTripTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/14/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

enum TripType {
    case Edit, New;
}

class JYJAddEditTripTableViewController: UIViewController, UINavigationBarDelegate {
    
    weak var delegate: JYJFlightsBaseViewController?
    var trip: Trip!
    var type: TripType = .New;
    @IBOutlet var tableView : UITableView
    @IBOutlet var navigationBar : UINavigationBar
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.pomegranateFlatColor();
        self.navigationBar.translucent = false;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationBar.delegate = self;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.registerNib(UINib(nibName: "JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
        
        if(self.type == TripType.New) {
            self.trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: (((UIApplication.sharedApplication()).delegate) as JYJAppDelegate).managedObjectContext) as Trip;
        }
        println("end of viewDidLoad()");
        
    }
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    @IBAction func cancelPressed(sender : AnyObject) {
        ((UIApplication.sharedApplication().delegate) as JYJAppDelegate).managedObjectContext.rollback();
        self.delegate!.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        ((UIApplication.sharedApplication().delegate) as JYJAppDelegate).managedObjectContext.save(nil);
        self.delegate!.dismissViewControllerAnimated(true, completion: nil);
    }
}

extension JYJAddEditTripTableViewController: UITableViewDelegate, UITableViewDataSource {

    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 2;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 1 ? 1 : trip.flights.count+1;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        println("in cellForRowAtIndexPath");
        println("indexPath: \(indexPath.description)");
        
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        println("identifier: "+identifier);
        switch identifier {
        case "titleCell":
            var cell: LabelAndTextFieldTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as LabelAndTextFieldTableViewCell;
            return cell;
            
        case "flightCell":
            var cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as JYJFlightTableViewCell;
            var flight = self.trip.flights[indexPath.row] as Flight;
            cell.flightLabel.text = "\(flight.airlineCode) \(flight.flightNumber)";
            let type = flight.flightType.integerValue;
            
            var formatter = NSDateFormatter();
            formatter.dateStyle = NSDateFormatterStyle.LongStyle;
            
            switch(type) {
            case FlightType.Departing.toRaw(), FlightType.Leg.toRaw():
                cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
            case FlightType.Arriving.toRaw():
                cell.dateLabel.text = formatter.stringFromDate(flight.arrivalTime);
            default:
                cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
                
            }
            cell.airportsLabel.text = "\(flight.originAirportCode) to \(flight.destinationAirportCode)";
            
            formatter.dateFormat = "h:mm a";
            cell.departureTimeLabel.text = formatter.stringFromDate(flight.departureTime);
            cell.arrivalTimeLabel.text = formatter.stringFromDate(flight.arrivalTime);
            
            return cell;
            
        case "addFlightCell":
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell;
            return cell;
            
        default:
            return UITableViewCell();
        }
        
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        switch(indexPath.section) {
        case 0:
            return "titleCell";
        case 1:
            return indexPath.row == trip.flights.count ? "addFlightCell" : "flightCell";
        default:
            return "";
        }
    }

}
