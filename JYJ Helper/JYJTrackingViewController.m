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
    
}

#pragma mark - table view delegate/data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.trackedObjectsList.count+1;
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
    if(indexPath.section == self.trackedObjectsList.count)
        identifier = @"addSectionCell";
    else if(indexPath.row == [self.trackedObjectsList[indexPath.section][@"queue"] count])
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
    else if([identifier isEqualToString:@"addSectionCell"])
        cell.textLabel.text = @"Add new section...";
    else {
        JYJAddCell *addCell = (JYJAddCell *)cell;
        [addCell.addJasonButton setTitleColor:[UIColor peterRiverFlatColor] forState:UIControlStateNormal];
        [addCell.addKevinButton setTitleColor:[UIColor greenSeaFlatColor] forState:UIControlStateNormal];
        [addCell.deleteSectionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }

    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == self.trackedObjectsList.count || indexPath.row == [self.trackedObjectsList[indexPath.section][@"queue"] count])
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section < self.trackedObjectsList.count)
        return;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Section" message:@"Enter new section name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = AlertViewSelectionNewSection;
    [alert show];
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - UIAlertView delegate method

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag == AlertViewSelectionNewSection) {
        if(buttonIndex == 0)
            return;
        
        NSString *title = [alertView textFieldAtIndex:0].text;
        if(!title || [title isEqualToString:@""])
            return;
        NSLog(@"title: %@", title);
        
        [self.trackedObjectsList addObject:@{@"title" : title, @"queue" : [NSMutableArray new]}];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(alertView.tag == AlertViewSelectionAreYouSure) {
        
        if(buttonIndex == 0) {
            self.currentSectionAboutToBeDeleted = -1;
            return;
        }
        
        [self.trackedObjectsList removeObjectAtIndex:self.currentSectionAboutToBeDeleted];
        [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.currentSectionAboutToBeDeleted] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.tableView reloadData];
        
        self.currentSectionAboutToBeDeleted = -1;
    }
}

#pragma mark - target action methods

- (IBAction)addJason:(UIButton *)sender {
//    NSLog(@"add Jason");
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"indexPath = (section,row) = (%ld, %ld)", (long)indexPath.section, (long)indexPath.row);
    
    [self.trackedObjectsList[indexPath.section][@"queue"] addObject:@"Jason"];
    [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.trackedObjectsList[indexPath.section][@"queue"] count] inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}
- (IBAction)addKevin:(UIButton *)sender {
//    NSLog(@"add Kevin");
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"indexPath = (section,row) = (%ld, %ld)", indexPath.section, (long)indexPath.row);
    [self.trackedObjectsList[indexPath.section][@"queue"] addObject:@"Kevin"];
    [[NSUserDefaults standardUserDefaults] setObject:self.trackedObjectsList forKey:@"trackedObjectList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.trackedObjectsList[indexPath.section][@"queue"] count] inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}
- (IBAction)deleteSection:(UIButton *)sender {

    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.currentSectionAboutToBeDeleted = indexPath.section;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Delete this section?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = AlertViewSelectionAreYouSure;
    [alert show];

}
@end
