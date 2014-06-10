//
//  JYJBusSettingsViewController.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/9/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelAndSwitchCellTableViewCell.h"

@interface JYJBusSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

-(void)didChangeSwitch:(BOOL)selected;

@end
