//
//  JYJTripsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJTripsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segToolbar: UIToolbar!
    @IBOutlet weak var segControl: UISegmentedControl!
    var myTrips: [Trip] = {
        var managedObjectContext = (UIApplication.sharedApplication().delegate as! JYJAppDelegate).managedObjectContext;
        var fetchRequest = NSFetchRequest(entityName: "Trip");
        return managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Trip];
    }();

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "JYJTripTableViewCell", bundle: nil), forCellReuseIdentifier: "tripCell");
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationController!.navigationBar.barTintColor = UIColor.alizarinFlatColor();
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.translucent = false;
        self.title = "Travel";
        
        self.segToolbar.barTintColor = UIColor.alizarinFlatColor();
    }

    override func viewWillAppear(animated: Bool) {
        self.reloadCoreData();
        
        self.navigationController!.navigationBar.hideBottomHairline();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Trips";
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.myTrips.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "tripCell";
        
        var cell: JYJTripTableViewCell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as! JYJTripTableViewCell;

        let trip = self.myTrips[indexPath.row];
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "MMMM d";
        if(trip.storedTimeZone != nil) {
            formatter.timeZone = NSTimeZone(name: trip.storedTimeZone);
        }

        cell.nameLabel.text = trip.name;
        cell.startDateLabel.text = formatter.stringFromDate(trip.startDate);
        cell.endDateLabel.text = formatter.stringFromDate(trip.endDate);

        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

//        let flightsVC: JYJFlightsTableViewController = self.storyboard.instantiateViewControllerWithIdentifier("flightsVC") as JYJFlightsTableViewController;
//        flightsVC.trip = self.myTrips[indexPath.row];
//        self.navigationController .pushViewController(flightsVC, animated: true);

        self.performSegueWithIdentifier("pushFlightsVC", sender: self.tableView.cellForRowAtIndexPath(indexPath));
        
        if(self.tableView.indexPathForSelectedRow() != nil) {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow()!, animated: true);
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            self.tableView.beginUpdates();
            let trip = self.myTrips[indexPath.row];
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! JYJAppDelegate).managedObjectContext;
            managedObjectContext.deleteObject(trip);
            managedObjectContext.save(nil);
            self.myTrips.removeAtIndex(indexPath.row);
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic);
            self.tableView.endUpdates();
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    func reloadCoreData() {
        var managedObjectContext = (UIApplication.sharedApplication().delegate as! JYJAppDelegate).managedObjectContext;
        var fetchRequest = NSFetchRequest(entityName: "Trip");
        var sortDescriptor = NSSortDescriptor(key: "startDate", ascending: true);
        fetchRequest.sortDescriptors = [sortDescriptor];
        let predicate = (self.segControl.selectedSegmentIndex == 0) ? NSPredicate(format: "SELF.endDate >= %@", NSDate()) : NSPredicate(format: "SELF.endDate <= %@", NSDate());
        fetchRequest.predicate = predicate;
        
        myTrips = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as! [Trip];
        self.tableView.reloadData();
    }
    @IBAction func segControlPressed(sender: AnyObject) {
        self.reloadCoreData();
    }
}

// segues
extension JYJTripsTableViewController: AddEditTripDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if(segue.identifier == "addNewTripSegue") {
            let destinationVC: JYJAddEditTripTableViewController = segue.destinationViewController as! JYJAddEditTripTableViewController;
            destinationVC.delegate = self;
        }
        else if(segue.identifier == "pushFlightsVC") {
            let flightsVC: JYJFlightsTableViewController = segue.destinationViewController as! JYJFlightsTableViewController;
            flightsVC.trip = self.myTrips[self.tableView.indexPathForCell(sender as! UITableViewCell)!.row];
        }
        
    }
    func didFinishCreatingOrEditingATrip() {
        self.dismissViewControllerAnimated(true, completion: nil);
        self.reloadCoreData();
    }
}