//
//  JYJViewController.h
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJNextBusViewController.h"

@interface JYJBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(IBAction)doneWithWebView:(UIStoryboardSegue *)segue;

@end
