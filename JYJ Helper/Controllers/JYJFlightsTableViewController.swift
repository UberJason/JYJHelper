//
//  JYJFlightsTableViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/11/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsTableViewController: JYJAbstractPageContentViewController {
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        self.pageIndex = 1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName:"JYJFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "flightCell");
    }
    
    // #pragma mark - Table view data source
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String {
        return "June Trip";
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2;
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "flightCell";
        
        var cell: JYJFlightTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? JYJFlightTableViewCell;
        
        cell!.flightLabel.text = "UA 999";
        cell!.dateLabel.text = "June 13, 2014";
        cell!.airportsLabel.text = "IAD to SFO";
        cell!.departureTimeLabel.text = "8:55 AM";
        cell!.arrivalTimeLabel.text = "11:38 AM";
        
        return cell!;
    }
    
}
