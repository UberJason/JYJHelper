//
//  JYJAddNewFlightViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/14/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

enum FlightViewType {
    case Edit, New;
}

let NUMBER_OF_FIELDS = 6;

let DEPARTURE_TIME_CELL_TAG = 33;
let ARRIVAL_TIME_CELL_TAG = 34;
let DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG = 35;
let ARRIVAL_DATEPICKER_TABLEVIEW_CELL_TAG = 36;

let FLIGHT_NUMBER_ROW = 1;
let DEPARTURE_DATEPICKER_ROW = 3;
let ARRIVAL_DATEPICKER_ROW = 4;

class JYJAddNewFlightViewController: UIViewController {
    
    @IBOutlet var navigationBar : UINavigationBar
    @IBOutlet var tableView : UITableView
    
    weak var delegate: JYJAddEditTripTableViewController?;
    let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
    var flight: Flight!;
    var type: FlightViewType = FlightViewType.New;
    
    var departurePickerShowing = false;
    var arrivalPickerShowing = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationBar.barTintColor = UIColor.pomegranateFlatColor();
        self.navigationBar.translucent = false;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationBar.delegate = self;
        
        if(self.type == FlightViewType.New) {
            self.flight = NSEntityDescription.insertNewObjectForEntityForName("Flight", inManagedObjectContext: self.context) as Flight;
            self.flight.trip = self.delegate!.trip;
            self.title = "Add New Flight";
        }
        else {
            self.title = "Edit Flight";
        }
    }
    
    @IBAction func cancelPressed(sender : AnyObject) {
        self.delegate!.didCancelAddingOrEditingAFlight();
    }
    
    @IBAction func savePressed(sender : UIBarButtonItem) {
        self.view.endEditing(true);
        self.flight.storedTimeZone = NSTimeZone.systemTimeZone().name;
        self.context.save(nil);
        self.delegate!.didFinishAddingOrEditingAFlight();
    }
    
}

extension JYJAddNewFlightViewController : UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UITextFieldDelegate, UIActionSheetDelegate, DatePickerDelegate {
    // #pragma mark - Table view data source
    
    func tableView(tableView: UITableView?, titleForHeaderInSection section: Int) -> String {
        return "Flight Details";
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView?, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        return identifier == "datePickerCell" ? 163 : 44;
        
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.departurePickerShowing || self.arrivalPickerShowing ? NUMBER_OF_FIELDS+1 : NUMBER_OF_FIELDS;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let identifier = self.identifierForRowAtIndexPath(indexPath!);
        println(identifier);
        switch(identifier) {
        case "textFieldCell":
            println(indexPath!.row);
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as LabelAndTextFieldTableViewCell;
            cell.titleLabel.text = self.leftLabelForRow(indexPath!.row);
            cell.textField.placeholder = self.rightPlaceholderTextForRow(indexPath!.row);
            cell.textField.textColor = UIColor.pomegranateFlatColor();
            if(indexPath!.row == FLIGHT_NUMBER_ROW) {
                cell.textField.keyboardType = UIKeyboardType.NumberPad;
            }
            cell.textField.delegate = self;
            cell.textField.tag = indexPath!.row;
            return cell;
        case "timeCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as TwoLabelTableViewCell;
            let leftLabel = self.leftLabelForRow(indexPath!.row);
            cell.leftLabel.text = leftLabel;
            cell.rightLabel.text = self.rightPlaceholderTextForRow(indexPath!.row);
            cell.rightLabel.textColor = UIColor.pomegranateFlatColor();
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
            if(indexPath!.row == DEPARTURE_DATEPICKER_ROW) {
                cell.tag = DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG;
                if(self.flight.departureTime) {
                    cell.datePicker.date = self.flight.departureTime;
                }
            }
            else {
                cell.tag = ARRIVAL_DATEPICKER_TABLEVIEW_CELL_TAG;
                if(self.flight.arrivalTime) {
                    cell.datePicker.date = self.flight.arrivalTime;
                }
            }
            return cell;
        case "flightTypePickerCell":
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as PickerCell;
            return cell;
        default:
            return nil;
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
    
    func rightPlaceholderTextForRow(row: Int) -> String {
        
        let dateString: String = {
            let formatter = NSDateFormatter();
            //            formatter.dateFormat = "h:mm a";
            formatter.dateFormat = "M/d/y, h:mm a";
            return formatter.stringFromDate(NSDate());
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
    
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = self.identifierForRowAtIndexPath(indexPath);
        if(identifier != "timeCell") {
            return;
        }
        println("did select row \(indexPath.row)");
        self.view.endEditing(true);
        let cell = tableView!.cellForRowAtIndexPath(indexPath);
        if(cell.tag == DEPARTURE_TIME_CELL_TAG) {
            
            tableView!.beginUpdates();
            if(self.departurePickerShowing) {
                tableView!.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            else {
                tableView!.insertRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            if(self.arrivalPickerShowing) {
                tableView!.deleteRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            
            self.departurePickerShowing = !self.departurePickerShowing;
            self.arrivalPickerShowing = false;
            
            tableView!.endUpdates();
        }
        else {
            
            tableView!.beginUpdates();
            if(self.arrivalPickerShowing) {
                tableView!.deleteRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            else {
                tableView!.insertRowsAtIndexPaths([NSIndexPath(forRow: ARRIVAL_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            if(self.departurePickerShowing) {
                tableView!.deleteRowsAtIndexPaths([NSIndexPath(forRow: DEPARTURE_DATEPICKER_ROW, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade);
            }
            
            self.arrivalPickerShowing = !self.arrivalPickerShowing;
            self.departurePickerShowing = false;
            tableView!.endUpdates();
            
        }
        
        tableView!.deselectRowAtIndexPath(tableView!.indexPathForSelectedRow(), animated: true);
    }
    
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        println("textfield \(textField.tag) ended editing");
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
    
    func cellDidChangeDate(cell: DatePickerCell, datePicker: UIDatePicker) {
        let tag = cell.tag;
        if(tag == DEPARTURE_DATEPICKER_TABLEVIEW_CELL_TAG) {
            println("departure time changed");
            self.flight.departureTime = datePicker.date;
            
            let departureCell = self.view.viewWithTag(DEPARTURE_TIME_CELL_TAG) as TwoLabelTableViewCell;
            departureCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateFormat = "M/d/y, h:mm a";
                return formatter.stringFromDate(self.flight.departureTime);
                }();
        }
        else {
            println("arrival time changed");
            self.flight.arrivalTime = datePicker.date;
            
            let arrivalCell = self.view.viewWithTag(ARRIVAL_TIME_CELL_TAG) as TwoLabelTableViewCell;
            arrivalCell.rightLabel.text = {
                let formatter = NSDateFormatter();
                formatter.dateFormat = "M/d/y, h:mm a";
                return formatter.stringFromDate(self.flight.arrivalTime);
                }();

        }
    }
    
}
