//
//  JYJAddNewFlightViewController.swift
//  JYJ Helper
//
//  Created by Jason Ji on 6/14/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

import UIKit

class JYJAddNewFlightViewController: UIViewController {
    
    @IBOutlet var navigationBar : UINavigationBar
    @IBOutlet var tableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.navigationBar.barTintColor = UIColor.pomegranateFlatColor();
        self.navigationBar.translucent = false;
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()];
        self.navigationBar.delegate = self;
    }
    
}

extension JYJAddNewFlightViewController : UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    // #pragma mark - Table view data source
    
    func tableView(tableView: UITableView?, titleForHeaderInSection section: Int) -> String {
        return "Flight Details";
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let identifier = self.identifierForRowAtIndexPath(indexPath!);
        println(identifier);
        switch(identifier) {
            case "textFieldCell":
                println(indexPath!.row);
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as LabelAndTextFieldTableViewCell;
                cell.titleLabel.text = self.leftLabelForRow(indexPath!.row);
                return cell;
            case "timeCell":
                var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as TwoLabelTableViewCell;
                return cell;
            default:
                return nil;
        }
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        switch(indexPath.row) {
        case 0...4:
            return "textFieldCell";
        case 5, 6:
            return "timeCell";
        default: return "no identifier";
        }
    }
    
    func leftLabelForRow(row: Int) -> String {
        switch(row) {
        case 0: return "Airline";
        case 1: return "Flight Number";
        case 2: return "Flight Type";
        case 3: return "Origin Airport";
        case 4: return "Destination Airport";
        default: return "";
        }
    }

    
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return UIBarPosition.TopAttached;
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
