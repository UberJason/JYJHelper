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
    
    let NUMBER_OF_DETAIL_FIELDS = 3;
    
    let DEPARTING_TIME_CELL_TAG = 33;
    let RETURNING_TIME_CELL_TAG = 34;
    let DEPARTING_DATEPICKER_CELL_TAG = 35;
    let RETURNING_DATEPICKER_CELL_TAG = 36;
    
    let DEPARTING_DATEPICKER_ROW = 2;
    let RETURNING_DATEPICKER_ROW = 3;
    
    weak var delegate : AddEditTripDelegate?
    let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! JYJAppDelegate).managedObjectContext;
    var trip: Trip!
    var type: TripViewType = .New;
    
    var cachedTrip: Trip?;
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var navigationBar : UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var activeTextField : UITextField?
    
    var departingPickerShowing = false;
    var returningPickerShowing = false;
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.alizarinFlatColor();
        self.navigationBar.translucent = false;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationBar.delegate = self;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.registerNib(UINib(nibName: "JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
        
        if(self.type == TripViewType.New) {
            self.trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: self.context) as! Trip;
            self.trip.flights = NSOrderedSet();
            self.trip.startDate = NSDate();
            self.trip.endDate = NSDate();
            self.navigationBar.topItem!.title = "Add New Trip";
        }
        else {
            
            self.cachedTrip = Trip(name: self.trip.name, startDate: self.trip.startDate, endDate: self.trip.endDate, storedTimeZone: self.trip.storedTimeZone, inManagedObjectContext: self.context);
            self.navigationBar.topItem!.title = "Edit Trip";
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
        
        if(self.tableView.indexPathForSelectedRow() != nil) {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow()!, animated: false);
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    @IBAction func cancelPressed(sender : AnyObject) {
        if(self.type == TripViewType.New) {
            self.context.deleteObject(self.trip);
            self.context.save(nil);
        }
        else {
            self.trip.name = self.cachedTrip!.name;
            self.trip.startDate = self.cachedTrip!.startDate;
            self.trip.endDate = self.cachedTrip!.endDate;
            self.trip.storedTimeZone = self.cachedTrip!.storedTimeZone;
            self.context.deleteObject(self.cachedTrip!);
        }
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        self.view.endEditing(true);
        println("trip name: \(self.trip.name)");
        if(self.trip.name == nil || self.trip.name == "") {
            UIAlertView.showWithTitle("Error", message: "You must specify a name for this trip.", cancelButtonTitle: "OK", otherButtonTitles: nil, tapBlock: nil);
        }
        else {
            if(self.cachedTrip != nil) {
                self.context.deleteObject(self.cachedTrip!);
            }
            self.context.save(nil);
            self.delegate!.didFinishCreatingOrEditingATrip();
        }
    }
}

// UITableView, UITextField delegate/data source

extension JYJAddEditTripTableViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DatePickerDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Trip Details";
        case 1: return "Flight Information";
        default: return "";
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        if(identifier == "flightCell") {
            return 88;
        }
        else if(identifier == "datePickerCell") {
            return 163;
        }
        else {
            return 44;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //        println("numberOfRowsInSection \(section)");
        if(section == 0) {
            return self.departingPickerShowing || self.returningPickerShowing ? NUMBER_OF_DETAIL_FIELDS+1 : NUMBER_OF_DETAIL_FIELDS;
        }
        else {
            return trip.flights.count+1;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        println("cellForRowAtIndexPath: \(indexPath.description)");
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        //        println(identifier);
        switch identifier {
            
        case "titleCell":
            var cell: LabelAndTextFieldTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! LabelAndTextFieldTableViewCell;
            cell.textField.delegate = self;
            //            println(cell.textField.delegate.description);
            cell.textField.text = self.trip.name;
            return cell;
        case "timeCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! TwoLabelTableViewCell;
            let leftLabel = self.leftLabelForRow(indexPath.row);
            cell.leftLabel.text = leftLabel;
            cell.rightLabel.text = {
                let date = (leftLabel == "Start Date" ? self.trip.startDate : self.trip.endDate);
                if(date != nil) {
                    let formatter = NSDateFormatter();
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle;
                    return formatter.stringFromDate(date);
                }
                else {
                    return self.rightPlaceholderTextForRow(indexPath.row);
                }
                }();
            cell.rightLabel.textColor = UIColor.alizarinFlatColor();
            if(leftLabel == "Start Date") {
                cell.tag = DEPARTING_TIME_CELL_TAG;
            }
            else {
                cell.tag = RETURNING_TIME_CELL_TAG;
            }
            return cell;
        case "datePickerCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! DatePickerCell;
            cell.delegate = self;
            if(indexPath.row == DEPARTING_DATEPICKER_ROW) {
                cell.tag = DEPARTING_DATEPICKER_CELL_TAG;
                if(self.trip.startDate != nil) {
                    cell.datePicker.date = self.trip.startDate;
                }
            }
            else {
                cell.tag = RETURNING_DATEPICKER_CELL_TAG;
                if(self.trip.endDate != nil) {
                    cell.datePicker.date = self.trip.endDate;
                }
            }
            return cell;
        case "flightCell":
            var cell: JYJFlightTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! JYJFlightTableViewCell;
            var flight = self.trip.flights[indexPath.row] as! Flight;
            cell.flightLabel.text = "\(flight.airlineCode) \(flight.flightNumber)";
            
            var formatter = NSDateFormatter();
            formatter.dateStyle = NSDateFormatterStyle.LongStyle;
            if(flight.storedTimeZone != nil) {
                formatter.timeZone = NSTimeZone(name: flight.storedTimeZone);
            }
            cell.dateLabel.text = formatter.stringFromDate(flight.departureTime);
            cell.airportsLabel.text = "\(flight.originAirportCode) to \(flight.destinationAirportCode)";
            
            formatter.dateFormat = "h:mm a";
            cell.departureTimeLabel.text = formatter.stringFromDate(flight.departureTime);
            cell.arrivalTimeLabel.text = formatter.stringFromDate(flight.arrivalTime);
            
            return cell;
        case "addFlightCell":
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell;
            return cell;
        default:
            return UITableViewCell();
        }
        
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        //        println("identifierForRowAtIndexPath: \(indexPath.section)");
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return "titleCell";
            case 1: return "timeCell";
            case 2: return self.departingPickerShowing ? "datePickerCell" : "timeCell";
            case 3: return self.returningPickerShowing ? "datePickerCell" : "timeCell";
            default: return "";
            }
        case 1:
            return indexPath.row == self.trip.flights.count ? "addFlightCell" : "flightCell";
        default:
            return "";
        }
    }
    
    func leftLabelForRow(row: Int) -> String {
        switch(row) {
        case 0: return "Trip Name";
        case 1: return "Start Date";
        case 2: return "End Date";
        case 3: return "End Date";
        default: return "ERROR";
        }
    }
    
    func rightPlaceholderTextForRow(row: Int) -> String {
        let dateString: String = {
            let formatter = NSDateFormatter();
            formatter.dateStyle = NSDateFormatterStyle.LongStyle;
            return formatter.stringFromDate(NSDate());
            }();
        switch(row) {
        case 0: return "Trip Name";
        case 1,2,3: return dateString;
        default: return "ERROR";
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        if(identifier == "flightCell") {
            self.performSegueWithIdentifier("editFlightSegue", sender: self.trip.flights[indexPath.row] as! Flight);
        }
        if(identifier == "timeCell") {
            
            self.view.endEditing(true);
            let cell = tableView.cellForRowAtIndexPath(indexPath)!;
            if(cell.tag == DEPARTING_TIME_CELL_TAG) {
                
                tableView.beginUpdates();
                if(self.departingPickerShowing) {
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                else {
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: DEPARTING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                if(self.returningPickerShowing) {
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: RETURNING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                
                self.departingPickerShowing = !self.departingPickerShowing;
                self.returningPickerShowing = false;
                
                tableView.endUpdates();
            }
            else {
                
                tableView.beginUpdates();
                if(self.returningPickerShowing) {
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: RETURNING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                else {
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: RETURNING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                if(self.departingPickerShowing) {
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTING_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
                }
                
                self.returningPickerShowing = !self.returningPickerShowing;
                self.departingPickerShowing = false;
                tableView.endUpdates();
                
            }
        }
        if(tableView.indexPathForSelectedRow() != nil) {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true);
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //        println("should return?");
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil;
        self.trip.name = textField.text;
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo as Dictionary!;
        let keyboardSize = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
        var aRect : CGRect = self.view.frame;
        aRect.size.height = aRect.size.height - keyboardSize!.height;
        
        if let currentField = self.activeTextField {
            let origin = self.view.convertPoint(currentField.frame.origin, fromView: currentField.superview);
            if(!CGRectContainsPoint(aRect, CGPoint(x: origin.x, y: origin.y+currentField.frame.size.height))) {
                self.tableView.scrollRectToVisible(currentField.frame, animated: true);
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    func cellDidChangeDate(cell: DatePickerCell, datePicker: UIDatePicker) {
        let tag = cell.tag;
        if(tag == DEPARTING_DATEPICKER_CELL_TAG) {
            //            println("departure time changed");
            self.trip.startDate = datePicker.date;
            
            let departureCell = self.view.viewWithTag(DEPARTING_TIME_CELL_TAG) as! TwoLabelTableViewCell;
            departureCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateStyle = NSDateFormatterStyle.LongStyle;
                return formatter.stringFromDate(self.trip.startDate);
                }();
            
            if(self.trip.startDate.compare(self.trip.endDate) == NSComparisonResult.OrderedDescending) {
                self.trip.endDate = self.trip.startDate;
                
                let arrivalCell = self.view.viewWithTag(RETURNING_TIME_CELL_TAG) as! TwoLabelTableViewCell;
                arrivalCell.rightLabel.text = {
                    let formatter = NSDateFormatter();
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle;
                    return formatter.stringFromDate(self.trip.endDate);
                    }();
            }
        }
        else {
            //            println("arrival time changed");
            self.trip.endDate = datePicker.date;
            
            let arrivalCell = self.view.viewWithTag(RETURNING_TIME_CELL_TAG) as! TwoLabelTableViewCell;
            arrivalCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateStyle = NSDateFormatterStyle.LongStyle;
                return formatter.stringFromDate(self.trip.endDate);
                }();
            
            if(self.trip.endDate.compare(self.trip.startDate) == NSComparisonResult.OrderedAscending) {
                self.trip.startDate = self.trip.endDate;
                
                let departureCell = self.view.viewWithTag(DEPARTING_TIME_CELL_TAG) as! TwoLabelTableViewCell;
                departureCell.rightLabel.text = {
                    let formatter = NSDateFormatter();
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle;
                    return formatter.stringFromDate(self.trip.startDate);
                    }();
            }
            
        }
    }
}

// segues

extension JYJAddEditTripTableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "addNewFlightSegue") {
            let controller = segue.destinationViewController as! JYJAddEditFlightController;
            controller.delegate = self;
        }
        else if(segue.identifier == "editFlightSegue") {
            let controller = segue.destinationViewController as! JYJAddEditFlightController;
            controller.flight = sender as! Flight;
            controller.type = FlightViewType.Edit;
            controller.delegate = self;
        }
    }
    
    func didFinishAddingOrEditingAFlight() {
        self.dismissViewControllerAnimated(true, completion: {
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade);
        });
        if(self.type == TripViewType.Edit) {
            self.navigationBar.topItem!.setLeftBarButtonItem(nil, animated: false);
        }
        
    }
    
    func didCancelAddingOrEditingAFlight() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
