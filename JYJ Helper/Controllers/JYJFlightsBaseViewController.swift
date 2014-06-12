//
//  JYJFlightsViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJFlightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navigationBar : UINavigationBar
    @IBOutlet var tableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.registerClass(JYJFlightTableViewCell.classForCoder(), forCellReuseIdentifier: "flightCell");
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        navigationBar.barTintColor = UIColor.pomegranateFlatColor();
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String {
        return "My Flights";
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "flightCell";
        
        var cell: JYJFlightTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? JYJFlightTableViewCell;
        
        if(!cell) {
            cell = JYJFlightTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier);
            
        }
    
        cell!.flightTitleLabel.text = "UA 999";
        cell!.dateLabel.text = "June 13, 2014";
        cell!.airportsLabel.text = "IAD to SFO";
        cell!.startTimeLabel.text = "8:55 AM";
        cell!.endTimeLabel.text = "11:38 AM";
        
        return cell!;
    }
    
}
