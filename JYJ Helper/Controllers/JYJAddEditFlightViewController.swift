//
//  JYJAddEditFlightController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/14/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

enum FlightViewType {
    case Edit, New;
}

class JYJAddEditFlightController: UIViewController {

    let NUMBER_OF_FIELDS = 6;
    
    let DEPARTURE_TIME_CELL_TAG = 33;
    let ARRIVAL_TIME_CELL_TAG = 34;
    let DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG = 35;
    let ARRIVAL_DATEPICKER_TABLEVIEW_CELL_TAG = 36;
    
    let FLIGHT_NUMBER_ROW = 1;
    let DEPARTURE_DATEPICKER_ROW = 3;
    let ARRIVAL_DATEPICKER_ROW = 4;
    
    @IBOutlet weak var navigationBar : UINavigationBar!
    @IBOutlet weak var tableView : UITableView!
    
    var activeTextField : UITextField?
    
    weak var delegate: JYJAddEditTripTableViewController?;
    let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
    var flight: Flight!;
    var type: FlightViewType = FlightViewType.New;
    
    var cachedFlight: Flight?;
    
    var departurePickerShowing = false;
    var arrivalPickerShowing = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationBar.barTintColor = UIColor.alizarinFlatColor();
        self.navigationBar.translucent = false;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationBar.delegate = self;
        
        if(self.type == FlightViewType.New) {
            self.flight = NSEntityDescription.insertNewObjectForEntityForName("Flight", inManagedObjectContext: self.context) as Flight;
            self.flight.trip = self.delegate!.trip;
            self.flight.arrivalTime = NSDate();
            self.flight.departureTime = NSDate();
            self.navigationBar.topItem!.title = "Add New Flight";
        }
        else {
            
            self.cachedFlight = Flight(airline: self.flight.airlineCode, flightNumber: self.flight.flightNumber, originAirportCode: self.flight.originAirportCode, destinationAirportCode: self.flight.destinationAirportCode, departureTime: self.flight.departureTime, arrivalTime: self.flight.arrivalTime, storedTimeZone: self.flight.storedTimeZone, inManagedObjectContext: self.context);
            self.navigationBar.topItem!.title = "Edit Flight";
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    @IBAction func cancelPressed(sender : AnyObject) {
        if(self.type == FlightViewType.New) {
            self.context.deleteObject(self.flight);
        }
        else {
            self.flight.airlineCode = self.cachedFlight!.airlineCode;
            self.flight.flightNumber = self.cachedFlight!.flightNumber;
            self.flight.originAirportCode = self.cachedFlight!.originAirportCode;
            self.flight.destinationAirportCode = self.cachedFlight!.destinationAirportCode;
            self.flight.departureTime = self.cachedFlight!.departureTime;
            self.flight.arrivalTime = self.cachedFlight!.arrivalTime;
            self.flight.storedTimeZone = self.cachedFlight!.storedTimeZone;
            self.context.deleteObject(self.cachedFlight!);
        }
        
        self.delegate!.didCancelAddingOrEditingAFlight();
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        self.view.endEditing(true);

        if(self.flight.arrivalTime.compare(self.flight.departureTime) == NSComparisonResult.OrderedAscending) {
            UIAlertView.showWithTitle("Error", message: "Arrival time must be after departure time.", cancelButtonTitle: "OK", otherButtonTitles: nil, tapBlock: nil);
        }
        else {
            self.flight.storedTimeZone = NSTimeZone.systemTimeZone().name;

            if(self.cachedFlight != nil) {
                self.context.deleteObject(self.cachedFlight!);
            }
            self.context.save(nil);
            self.delegate!.didFinishAddingOrEditingAFlight();
        }
    }
    
}

extension JYJAddEditFlightController : UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextFieldDelegate, UIActionSheetDelegate, DatePickerDelegate {
    // #pragma mark - Table view data source
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "Flight Details";
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        return identifier == "datePickerCell" ? 163 : 44;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.departurePickerShowing || self.arrivalPickerShowing ? NUMBER_OF_FIELDS+1 : NUMBER_OF_FIELDS;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        switch(identifier) {
        case "textFieldCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as LabelAndTextFieldTableViewCell;
            cell.titleLabel.text = self.leftLabelForRow(indexPath.row);
            cell.textField.placeholder = self.rightPlaceholderTextForRow(indexPath.row);
            cell.textField.text = self.rightTextForRow(indexPath.row);
            cell.textField.textColor = UIColor.alizarinFlatColor();
            cell.textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters;
            if(indexPath.row == FLIGHT_NUMBER_ROW) {
                cell.textField.keyboardType = UIKeyboardType.NumberPad;
            }
            cell.textField.delegate = self;
            cell.textField.tag = indexPath.row;
            return cell;
        case "timeCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as TwoLabelTableViewCell;
            let leftLabel = self.leftLabelForRow(indexPath.row);
            cell.leftLabel.text = leftLabel;
//            cell.rightLabel.text = self.rightPlaceholderTextForRow(indexPath!.row);
            
            let date = (leftLabel == "Departs" ? self.flight.departureTime : self.flight.arrivalTime);
            
            let dateString: String = {
                let formatter = NSDateFormatter();
                formatter.dateFormat = "M/d/y, h:mm a";
                return formatter.stringFromDate(date ?? NSDate());
                }();
            
            cell.rightLabel.text = dateString;
            cell.rightLabel.textColor = UIColor.alizarinFlatColor();
            if(leftLabel == "Departs") {
                cell.tag = DEPARTURE_TIME_CELL_TAG;
            }
            else {
                cell.tag = ARRIVAL_TIME_CELL_TAG;
            }
            return cell;
        case "datePickerCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as DatePickerCell;
            cell.delegate = self;
            if(indexPath.row == DEPARTURE_DATEPICKER_ROW) {
                cell.tag = DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG;
                if(self.flight.departureTime != nil) {
                    cell.datePicker.date = self.flight.departureTime;
                }
            }
            else {
                cell.tag = ARRIVAL_DATEPICKER_TABLEVIEW_CELL_TAG;
                if(self.flight.arrivalTime != nil) {
                    cell.datePicker.date = self.flight.arrivalTime;
                }
            }
            return cell;
        default:
            return UITableViewCell();
        }
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        
        switch(indexPath.row) {
        case 0, 1:
            return "textFieldCell";
        case 2:
            return "timeCell";
        case 3:
            return self.departurePickerShowing ? "datePickerCell" : "timeCell";
        case 4:
            if(self.departurePickerShowing) {
                return "timeCell";
            }
            else if(self.arrivalPickerShowing) {
                return "datePickerCell";
            }
            else {
                return "textFieldCell";
            }
        case 5, 6:
            return "textFieldCell";
        default: return "";
        }
    }
    
    func leftLabelForRow(row: Int) -> String {
        switch(row) {
        case 0: return "Airline";
        case 1: return "Flight Number";
        case 2: return "Departs";
        case 3: return "Arrives";
        case 4:
            if(self.departurePickerShowing) {
                return "Arrives";
            }
            else {
                return "Origin Airport";
            }
        case 5:
            if(self.departurePickerShowing || self.arrivalPickerShowing) {
                return "Origin Airport";
            }
            else {
                return "Destination Airport";
            }
        case 6:
            return "Destination Airport";
        default: return "";
        }
    }
    
    func rightTextForRow(row: Int) -> String {
        let dateString: String = {
            let formatter = NSDateFormatter();
            formatter.dateFormat = "M/d/y, h:mm a";
            return formatter.stringFromDate(self.delegate?.trip.startDate ?? NSDate());
            }();
        
        switch(row) {
        case 0:
            return self.flight.airlineCode ?? "";
        case 1:
            return self.flight.flightNumber != 0 ? "\(self.flight.flightNumber)" : "";
        case 2:
            return dateString;
        case 3:
            return dateString;
        case 4:
            if(self.departurePickerShowing) {
                return dateString;
            }
            else {
                return self.flight.originAirportCode ?? "";
            }
        case 5:
            if(self.departurePickerShowing || self.arrivalPickerShowing) {
                return self.flight.originAirportCode ?? "";
            }
            else {
                return self.flight.destinationAirportCode ?? "";
            }
        case 6:
            return self.flight.destinationAirportCode ?? "";
        default: return "";
        }
    }
    
    func rightPlaceholderTextForRow(row: Int) -> String {
        
        let dateString: String = {
            let formatter = NSDateFormatter();
            formatter.dateFormat = "M/d/y, h:mm a";
            return formatter.stringFromDate(self.delegate?.trip.startDate ?? NSDate());
            }();
        
        switch(row) {
        case 0:
            return "Airline Code";
        case 1:
            return "Flight Number";
        case 2:
            return dateString;
        case 3:
            return dateString;
        case 4:
            if(self.departurePickerShowing) {
                return dateString;
            }
            else {
                return "Origin";
            }
        case 5:
            if(self.departurePickerShowing || self.arrivalPickerShowing) {
                return "Origin";
            }
            else {
                return "Destination";
            }
        case 6:
            return "Destination";
        default: return "";
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        if(identifier != "timeCell") {
            return;
        }
//        println("did select row \(indexPath.row)");
        self.view.endEditing(true);
        let cell = tableView.cellForRowAtIndexPath(indexPath)!;
        if(cell.tag == DEPARTURE_TIME_CELL_TAG) {
            
            tableView.beginUpdates();
            if(self.departurePickerShowing) {
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            else {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            if(self.arrivalPickerShowing) {
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            
            self.departurePickerShowing = !self.departurePickerShowing;
            self.arrivalPickerShowing = false;
            
            tableView.endUpdates();
        }
        else {
            
            tableView.beginUpdates();
            if(self.arrivalPickerShowing) {
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            else {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            if(self.departurePickerShowing) {
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            
            self.arrivalPickerShowing = !self.arrivalPickerShowing;
            self.departurePickerShowing = false;
            tableView.endUpdates();
            
        }
        if(self.tableView.indexPathForSelectedRow() != nil) {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true);
        }
    }
    
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    func textFieldDidBeginEditing(textField:UITextField!) {
        self.activeTextField = textField;
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.activeTextField = nil;
//        println("textfield \(textField.tag) ended editing");
        switch(textField.tag) {
        case 0:
            self.flight.airlineCode = textField.text;
        case 1:
            self.flight.flightNumber = (textField.text as NSString).integerValue;
        case 4:
            self.flight.originAirportCode = textField.text;
        case 5:
            self.flight.destinationAirportCode = textField.text;
        default:
            break;
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
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
        if(tag == DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG) {
//            println("departure time changed");
            self.flight.departureTime = datePicker.date;
            
            let departureCell = self.view.viewWithTag(DEPARTURE_TIME_CELL_TAG) as TwoLabelTableViewCell;
            departureCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateFormat = "M/d/y, h:mm a";
                return formatter.stringFromDate(self.flight.departureTime);
                }();

            if(self.flight.departureTime.compare(self.flight.arrivalTime) == NSComparisonResult.OrderedDescending) {
                self.flight.arrivalTime = self.flight.departureTime;
                
                let arrivalCell = self.view.viewWithTag(ARRIVAL_TIME_CELL_TAG) as TwoLabelTableViewCell;
                arrivalCell.rightLabel.text = {
                    let formatter = NSDateFormatter();
                    formatter.dateFormat = "M/d/y, h:mm a";
                    return formatter.stringFromDate(self.flight.arrivalTime);
                    }();
            }
            
        }
        else {
//            println("arrival time changed");
            self.flight.arrivalTime = datePicker.date;
            
            let arrivalCell = self.view.viewWithTag(ARRIVAL_TIME_CELL_TAG) as TwoLabelTableViewCell;
            arrivalCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateFormat = "M/d/y, h:mm a";
                return formatter.stringFromDate(self.flight.arrivalTime);
                }();
            
            if(self.flight.arrivalTime.compare(self.flight.departureTime) == NSComparisonResult.OrderedAscending) {
                self.flight.departureTime = self.flight.arrivalTime;
                
                let departureCell = self.view.viewWithTag(DEPARTURE_TIME_CELL_TAG) as TwoLabelTableViewCell;
                departureCell.rightLabel.text = {
                    let formatter = NSDateFormatter();
                    formatter.dateFormat = "M/d/y, h:mm a";
                    return formatter.stringFromDate(self.flight.departureTime);
                }();
            }

        }
    }
    
}
