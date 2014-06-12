//
//  JYJFlightsBaseViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsBaseViewController: UIViewController, UIToolbarDelegate, UINavigationBarDelegate {
    
    @IBOutlet var navigationBar : UINavigationBar
    @IBOutlet var barView : UIView
    @IBOutlet var segmentedControl : UISegmentedControl
    @IBOutlet var containerView : UIView
    
    var pageController: UIPageViewController
    var myViewControllers: UIViewController[] = [];
    
    @lazy var tripsVC: JYJTripsTableViewController = {
        return self.storyboard.instantiateViewControllerWithIdentifier("tripsVC") as JYJTripsTableViewController;
        }();
    @lazy var flightsVC: JYJFlightsTableViewController = {
        return self.storyboard.instantiateViewControllerWithIdentifier("flightsVC") as JYJFlightsTableViewController;
        }();
    
    
    init(coder aDecoder: NSCoder!) {
        pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil);
        super.init(coder: aDecoder);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.delegate = self;
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        navigationBar.barTintColor = UIColor.pomegranateFlatColor();
        navigationBar.translucent = false;
        
        barView.backgroundColor = UIColor.pomegranateFlatColor();
        
        pageController.delegate = self;
        pageController.dataSource = self;
        
        myViewControllers.append(self.tripsVC);
        myViewControllers.append(self.flightsVC);
        
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated);
        pageController.view.frame = CGRectMake(0, 0, self.containerView.frame.width, self.containerView.frame.height);
        pageController.setViewControllers([self.tripsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil);
        
        self.addChildViewController(pageController);
        self.containerView.addSubview(pageController.view);
        pageController.didMoveToParentViewController(self);
    }
    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated);
        
    }
}

extension JYJFlightsBaseViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController? {
        let vc = viewController as JYJAbstractPageContentViewController;
        if(vc.pageIndex == 0) {
            return nil;
        }
        else {
            return self.myViewControllers[vc.pageIndex-1];
        }
        
    }
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController? {
        let vc = viewController as JYJAbstractPageContentViewController;
        if(vc.pageIndex == self.myViewControllers.count-1) {
            return nil;
        }
        else {
            return self.myViewControllers[vc.pageIndex+1];
        }
    }
}
