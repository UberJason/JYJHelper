//
//  JYJAddGameResultController.h
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJ_Helper-Swift.h"
#import "GameRecord+Helpers.h"

@interface JYJAddGameResultController : UIViewController<UIBarPositioningDelegate, UITableViewDataSource, UITableViewDelegate, DatePickerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GameRecord *record;

@end
