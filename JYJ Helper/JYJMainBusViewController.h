//
//  JYJViewController.h
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJNextBusViewController;

typedef NS_ENUM(NSInteger, BusSelected) {
    BusSelectedHome23A,
    BusSelectedHome23T,
    BusSelectedWork
};

@interface JYJMainBusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
