//
//  JYJBalloonCupHistoryController.m
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "JYJBalloonCupHistoryController.h"

@interface JYJBalloonCupHistoryController ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation JYJBalloonCupHistoryController

-(NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMMM d, YYYY, h:mm a";
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.model refreshCoreData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.gameRecords.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"gameCell";
    
    GameRecord *record = self.model.gameRecords[self.model.gameRecords.count - indexPath.row - 1];
    TwoLabelTableViewCell *cell = (TwoLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if([record.winner isEqualToString:@"Deadlock"]) {
        cell.leftLabel.text = record.winner;
        cell.leftLabel.textColor = [UIColor sunFlowerFlatColor];
    }
    else if([record.winner isEqualToString:@"Jason"]) {
        cell.leftLabel.text = @"Winner: Jason";
        cell.leftLabel.textColor = [UIColor emeraldFlatColor];
    }
    else {
        cell.leftLabel.text = @"Winner: Mary Anne";
        cell.leftLabel.textColor = [UIColor redColor];
    }
    
    cell.rightLabel.text = [self.dateFormatter stringFromDate:record.gameTime];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editGameSegue" sender:self.model.gameRecords[self.model.gameRecords.count - indexPath.row - 1]];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = ((JYJAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        GameRecord *record = self.model.gameRecords[self.model.gameRecords.count - indexPath.row - 1];
        [context deleteObject:record];
        [context save:nil];
        
        [self.model refreshCoreData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameRecord *record = (GameRecord *)sender;
    
    JYJAddGameResultController *controller = (JYJAddGameResultController *)segue.destinationViewController;
    controller.record = record;
    
}

@end
