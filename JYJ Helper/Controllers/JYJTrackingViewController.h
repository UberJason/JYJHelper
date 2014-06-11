//
//  JYJTrackingViewController.h
//  JYJ Helper
//
//  Created by Jason Ji on 12/28/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJAddCell.h"

@interface JYJTrackingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger currentSectionAboutToBeDeleted;

@end
