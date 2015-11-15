//
//  JYJTrackingViewController.m
//  JYJ Helper
//
//  Created by Jason Ji on 12/28/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJTrackingViewController.h"

typedef enum {
    AlertViewSelectionNewSection,
    AlertViewSelectionAreYouSure
} AlertViewSelection;

@interface JYJTrackingViewController ()

@property (strong, nonatomic) NSMutableArray *trackedObjectsList;
// NSMutableArray of NSMutableDictionaries.
// each NSMutableDictionary has {@"title" : <title>, @"queue" : <NSMutableArray of names>}
@end

@implementation JYJTrackingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationBar.delegate = self;
    self.navigationBar.barTintColor = [UIColor belizeHoleFlatColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delaysContentTouches = NO;
    self.trackedObjectsList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"trackedObjectList"] mutableCopy];

    if(!self.trackedObjectsList) {
//        NSLog(@"None, so I'm making it");
        self.trackedObjectsList = [@[
                                     @{@"title" : @"Gas", @"queue": [@[@"Jason"] mutableCopy] },
                                     @{@"title" : @"Popeyes", @"queue" : [@[@"Jason"] mutableCopy] }
                                     
                                     ] mutableCopy];
       [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        for(NSInteger i = 0; i < self.trackedObjectsList.count; i++) {
            self.trackedObjectsList[i] = [self.trackedObjectsList[i] mutableCopy];
            self.trackedObjectsList[i][@"queue"] = [self.trackedObjectsList[i][@"queue"] mutableCopy];
        }
    }
    
}

#pragma mark - UINavigationBarDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - table view delegate/data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.trackedObjectsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == self.trackedObjectsList.count)
        return @"";
    return self.trackedObjectsList[section][@"title"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == self.trackedObjectsList.count)
        return 1;
    return [self.trackedObjectsList[section][@"queue"] count]+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // self.trackedObjectsList[indexPath.section] gets an NSMutableDictionary for that section.
    // self.trackedObjectsList[indexPath.section][@"queue"][indexPath.row] gets the name at that row.
    
    NSString *identifier;
    if(indexPath.row == [self.trackedObjectsList[indexPath.section][@"queue"] count])
        identifier = @"addCell";
    else
        identifier = @"personCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if([identifier isEqualToString:@"personCell"]) {
        cell.textLabel.text = self.trackedObjectsList[indexPath.section][@"queue"][indexPath.row];
        if([cell.textLabel.text isEqualToString:@"Jason"])
            cell.textLabel.textColor = [UIColor peterRiverFlatColor];
        else
            cell.textLabel.textColor = [UIColor greenSeaFlatColor];
    }
    else {
        JYJAddCell *addCell = (JYJAddCell *)cell;
        [addCell.addJasonButton setTitleColor:[UIColor peterRiverFlatColor] forState:UIControlStateNormal];
        [addCell.addKevinButton setTitleColor:[UIColor greenSeaFlatColor] forState:UIControlStateNormal];
        [addCell.deleteSectionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        addCell.delegate = self;
    }

    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [self.trackedObjectsList[indexPath.section][@"queue"] count])
        return NO;
    else return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.trackedObjectsList[indexPath.section][@"queue"] removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (IBAction)addSection:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Section" message:@"Enter new section name" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *title = alert.textFields[0].text;
        if(!title || [title isEqualToString:@""])
            return;
        [self.trackedObjectsList addObject:@{@"title" : title, @"queue" : [NSMutableArray new]}];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - target action methods

- (void)addJason:(JYJAddCell *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    [self.trackedObjectsList[indexPath.section][@"queue"] addObject:@"Jason"];
    [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
- (void)addKevin:(JYJAddCell *)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    [self.trackedObjectsList[indexPath.section][@"queue"] addObject:@"Kevin"];
    [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}
- (void)deleteSection:(JYJAddCell *)sender {

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    self.currentSectionAboutToBeDeleted = indexPath.section;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Delete this section?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.currentSectionAboutToBeDeleted = -1;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.trackedObjectsList removeObjectAtIndex:self.currentSectionAboutToBeDeleted];
        [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.currentSectionAboutToBeDeleted] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.tableView reloadData];
        
        self.currentSectionAboutToBeDeleted = -1;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

}
@end
