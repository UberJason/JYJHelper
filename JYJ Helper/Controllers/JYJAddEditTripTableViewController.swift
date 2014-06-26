//
//  JYJAddEditTripTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/14/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

enum TripViewType {
    case Edit, New;
}

class JYJAddEditTripTableViewController: UIViewController, UINavigationBarDelegate {
    
    weak var delegate: JYJFlightsBaseViewController?
    let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
    var trip: Trip!
    var type: TripViewType = .New;
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
        
        if(self.type == TripViewType.New) {
            self.trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: self.context) as Trip;
            self.trip.flights = NSOrderedSet();
            self.title = "Add New Trip";
        }
        else {
            self.title = "Edit Trip";
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow(), animated: false);
    }
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    @IBAction func cancelPressed(sender : AnyObject) {
        if(self.type == TripViewType.New) {
            self.context.deleteObject(self.trip);
            self.context.save(nil);
        }
        self.delegate!.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        self.view.endEditing(true);
        if(!self.trip.name || self.trip.name == "") {
            UIAlertView.showWithTitle("Error", message: "You must specify a name for this trip.", cancelButtonTitle: "OK", otherButtonTitles: nil, tapBlock: nil);
        }
        else {
            self.context.save(nil);
            self.delegate!.dismissViewControllerAnimated(true, completion: nil);
            self.delegate!.didFinishCreatingOrEditingATrip();
        }
    }
}

// UITableView, UITextField delegate/data source

extension JYJAddEditTripTableViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(tableView: UITableView?, titleForHeaderInSection section: Int) -> String! {
        switch(section) {
        case 0: return "Trip Details";
        case 1: return "Flight Information";
        default: return "";
        }
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        if(identifier == "flightCell") {
            return 88;
        }
        else {
            return 44;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 2;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        println("numberOfRowsInSection \(section)");
        if(section == 0) {
            println("1 row");
            return 1;
        }
        else {
            println("number of rows = trip.flights.count = \(trip.flights.count)");
            return trip.flights.count+1;
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        println("cellForRowAtIndexPath: \(indexPath.description)");
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        println(identifier);
        switch identifier {

        case "titleCell":
            var cell: LabelAndTextFieldTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as LabelAndTextFieldTableViewCell;
            cell.textField.delegate = self;
            println(cell.textField.delegate.description);
            return cell;
            
        case "flightCell":
            var cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as JYJFlightTableViewCell;
            var flight = self.trip.flights[indexPath.row] as Flight;
            cell.flightLabel.text = "\(flight.airlineCode) \(flight.flightNumber)";
            
            var formatter = NSDateFormatter();
            formatter.dateStyle = NSDateFormatterStyle.LongStyle;
            formatter.timeZone = NSTimeZone(name: flight.storedTimeZone);
            cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
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
        println("identifierForRowAtIndexPath: \(indexPath.section)");
        switch(indexPath.section) {
        case 0:
            return "titleCell";
        case 1:
            return indexPath.row == self.trip.flights.count ? "addFlightCell" : "flightCell";
        default:
            return "";
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        println("should return?");
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.trip.name = textField.text;
    }
    
}

// segues

extension JYJAddEditTripTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.identifier == "addNewFlightSegue") {
            let controller = segue.destinationViewController as JYJAddNewFlightViewController;
            controller.delegate = self;
        }
    }
    
    func didFinishAddingOrEditingAFlight() {
        self.tableView.reloadData();
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func didCancelAddingOrEditingAFlight() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
