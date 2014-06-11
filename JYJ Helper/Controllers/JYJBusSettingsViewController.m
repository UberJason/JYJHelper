//
//  JYJBusSettingsViewController.m
//  JYJ Helper
//
//  Created by Jason Ji on 6/9/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "JYJBusSettingsViewController.h"

@interface JYJBusSettingsViewController ()

@end

@implementation JYJBusSettingsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.navigationBar.barTintColor = [UIColor emeraldFlatColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"General";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    LabelAndSwitchCellTableViewCell *cell = (LabelAndSwitchCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.control.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoShowBus"];
    cell.delegate = self;
    
    return cell;
}
- (IBAction)donePressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didChangeSwitch:(BOOL)selected {
    [[NSUserDefaults standardUserDefaults] setBool:selected forKey:@"autoShowBus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
