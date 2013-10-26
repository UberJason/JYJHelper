//
//  JYJViewController.m
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJBaseViewController.h"

typedef enum {
    BusSelectedHome,
    BusSelectedWork
} BusSelected;

@interface JYJBaseViewController ()

@property (strong, nonatomic) NSArray *busStops;

@end

@implementation JYJBaseViewController

-(NSArray *)busStops {
    if(!_busStops)
        _busStops = @[@"23A Home", @"23A Work"];
    return _busStops;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
}

#pragma mark - table view delegate/datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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

-(IBAction)doneWithWebView:(UIStoryboardSegue *)segue {
    NSLog(@"Done with segue");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pushWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        JYJNextBusViewController *newController = (JYJNextBusViewController *)segue.destinationViewController;
        newController.homeRequested = indexPath.row == BusSelectedHome;
    }
    
}
@end
