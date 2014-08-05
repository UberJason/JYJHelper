//
//  JYJFlightsBaseViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsBaseViewController: UIViewController, UIToolbarDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var navigationBar : UINavigationBar!
    
//    var pageController: UIPageViewController
//    var myViewControllers: [UIViewController] = [];
//    
//    @lazy var tripsVC: JYJTripsTableViewController = {
//        return self.storyboard.instantiateViewControllerWithIdentifier("tripsVC") as JYJTripsTableViewController;
//        }();
//    @lazy var flightsVC: JYJFlightsTableViewController = {
//        return self.storyboard.instantiateViewControllerWithIdentifier("flightsVC") as JYJFlightsTableViewController;
//        }();
    
    
    init(coder aDecoder: NSCoder!) {
//        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil);
        super.init(coder: aDecoder);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.delegate = self;
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        navigationBar.barTintColor = UIColor.alizarinFlatColor();
        navigationBar.translucent = false;
        
//        pageController.delegate = self;
//        pageController.dataSource = self;
        
//        myViewControllers.append(self.tripsVC);
//        myViewControllers.append(self.flightsVC);

        /*
        var calendar = NSCalendar.currentCalendar();
        calendar.timeZone = NSTimeZone.systemTimeZone();

        println("getting a reference to context");
        var context:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;
        
        var startTime = NSDateComponents();
        startTime.month = 6;
        startTime.day = 13;
        startTime.year = 2014;
        startTime.hour = 8;
        startTime.minute = 55;
        
        var endTime = NSDateComponents();
        endTime.month = 6;
        endTime.day = 13;
        endTime.year = 2014;
        endTime.hour = 11;
        endTime.minute = 38;
        
        var startTimeDate = calendar.dateFromComponents(startTime);
        var endTimeDate = calendar.dateFromComponents(endTime);
        
        println("making first flight");
        var firstFlight: Flight = Flight(airline: "UA", flightNumber: 999, flightType: Int(FlightType.Departing.toRaw()), originAirportCode: "IAD", destinationAirportCode: "SFO", departureTime: startTimeDate, arrivalTime: endTimeDate, inManagedObjectContext: context);
        
        startTime.hour = 11;
        startTime.minute = 0;
        startTime.day = 23;
        startTimeDate = calendar.dateFromComponents(startTime);
        
        endTime.hour = 18;
        endTime.minute = 16;
        endTime.day = 23;
        endTimeDate = calendar.dateFromComponents(endTime);
        
        println("making second flight");
        
        var secondFlight: Flight = Flight(airline: "UA", flightNumber: 1720, flightType: Int(FlightType.Arriving.toRaw()), originAirportCode: "SFO", destinationAirportCode: "IAD", departureTime: startTimeDate, arrivalTime: endTimeDate, inManagedObjectContext: context);

        println("making a trip");
        var trip: Trip = Trip(name: "June Trip", startDate: firstFlight.departureTime, endDate: secondFlight.arrivalTime, inManagedObjectContext: context);
    
        firstFlight.trip = trip;
        secondFlight.trip = trip;
        
        println("saving");
        context.save(nil);
        println("done");
*/
      /*
        var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as JYJAppDelegate).managedObjectContext;

        var entityDescription: NSEntityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context);
        var request = NSFetchRequest(entityName: "Trip");
        
        var error: NSError? = nil;
        var tripsArray = context.executeFetchRequest(request, error: &error);
        
        var thisTrip: Trip = tripsArray[0] as Trip;
        println(thisTrip.flights.count);

*/
        
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated);
//        pageController.view.frame = CGRectMake(0, 0, self.containerView.frame.width, self.containerView.frame.height);
//        pageController.setViewControllers([self.tripsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil);
//        
//        self.addChildViewController(pageController);
//        self.containerView.addSubview(pageController.view);
//        pageController.didMoveToParentViewController(self);
    }
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated);
        
    }

}

// UIPageViewController delegate and data source
//extension JYJFlightsBaseViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController? {
//        let vc = viewController as JYJAbstractPageContentViewController;
//        if(vc.pageIndex == 0) {
//            return nil;
//        }
//        else {
//            return self.myViewControllers[vc.pageIndex-1];
//        }
//        
//    }
//    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController? {
//        let vc = viewController as JYJAbstractPageContentViewController;
//        if(vc.pageIndex == self.myViewControllers.count-1) {
//            return nil;
//        }
//        else {
//            return self.myViewControllers[vc.pageIndex+1];
//        }
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController!, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject!], transitionCompleted completed: Bool) {
//        if(previousViewControllers[0] === self.tripsVC) {
//            self.segmentedControl.selectedSegmentIndex = 1;
//        }
//        else {
//            self.segmentedControl.selectedSegmentIndex = 0;
//        }
//    }
//}
//
//// target-action methods
//extension JYJFlightsBaseViewController {
//    @IBAction func controlPressed(sender : UISegmentedControl) {
//        if(sender.selectedSegmentIndex == 0) {
//            self.pageController.setViewControllers([self.tripsVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil);
//        }
//        else {
//            self.pageController.setViewControllers([self.flightsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil);
//        }
//    }
//}
//
// segues
//extension JYJFlightsBaseViewController {
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)  {
//        if(segue.identifier == "addNewTripSegue") {
//            var destinationVC: JYJAddEditTripTableViewController = segue.destinationViewController as JYJAddEditTripTableViewController;
//            destinationVC.delegate = self;
//        }
//        
//    }
//    func didFinishCreatingOrEditingATrip() {
////        self.tripsVC.reloadCoreData();
////        self.flightsVC.tableView.reloadData();
//    }
//}