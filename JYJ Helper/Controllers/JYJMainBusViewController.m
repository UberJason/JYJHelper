//
//  JYJViewController.m
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJMainBusViewController.h"
#import "JYJNextBusViewController.h"

@interface JYJMainBusViewController ()

@property (strong, nonatomic) NSArray *busStops;

@end

@implementation JYJMainBusViewController

-(NSArray *)busStops {
    if(!_busStops)
        _busStops = @[@"23A Home", @"23T Home", @"23A Work"];
    return _busStops;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor sunFlowerFlatColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
}

#pragma mark - table view delegate/datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"busCell"];
    cell.textLabel.text = self.busStops[indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section==0)
        return @"WMATA";
    
    return @"ERROR";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pushWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        JYJNextBusViewController *newController = (JYJNextBusViewController *)segue.destinationViewController;
        newController.homeRequested = (BusSelected)indexPath.row;
    }
    
}
@end
