//
//  JYJBalloonCupController.m
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "JYJBalloonCupController.h"

@interface JYJBalloonCupController ()

@property (strong, nonatomic) JYJBalloonCupModel *model;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation JYJBalloonCupController

-(NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMMM d, YYYY, h:mm a";
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[JYJBalloonCupModel alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor emeraldFlatColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.viewGameHistoryButton.layer.cornerRadius = 4.0f;
    self.viewGameHistoryButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewGameHistoryButton.layer.borderWidth = 1.0f;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.model refreshCoreData];
    
    NSInteger jasonWins = [self.model numberOfWinsForPlayer:@"Jason"];
    NSInteger makWins = [self.model numberOfWinsForPlayer:@"Mary Anne"];
    
    self.jasonWinLabel.text = [NSString stringWithFormat:@"%ld", jasonWins];
    self.makWinLabel.text = [NSString stringWithFormat:@"%ld", makWins];
    self.tiesLabel.text = [NSString stringWithFormat:@"%ld", [self.model numberOfWinsForPlayer:@"Deadlock"]];
    if(jasonWins > makWins) {
        self.overallLabel.text = [NSString stringWithFormat:@"Jason +%ld", jasonWins - makWins];
        self.overallLabel.textColor = [UIColor emeraldFlatColor];
        self.overallPanel.layer.borderColor = [UIColor emeraldFlatColor].CGColor;
    }
    else if(makWins > jasonWins) {
        self.overallLabel.text = [NSString stringWithFormat:@"Mary Anne +%ld", makWins - jasonWins];
        self.overallLabel.textColor = [UIColor redColor];
        self.overallPanel.layer.borderColor = [UIColor redColor].CGColor;
    }
    else {
        self.overallLabel.text = @"+0 Even";
        self.overallLabel.textColor = [UIColor grayColor];
        self.overallPanel.layer.borderColor = [UIColor grayColor].CGColor;
    }
    self.overallPanel.layer.borderWidth = 1.0f;
    self.overallPanel.layer.cornerRadius = 7.0f;
    self.overallPanel.clipsToBounds = YES;
    
    GameRecord *lastRecord = [self.model mostRecentGameRecord];
    
    if([lastRecord.winner isEqualToString:@"Jason"]) {
        self.lastGameResultLabel.text = @"Winner: Jason";
        self.lastGameResultLabel.textColor = [UIColor emeraldFlatColor];
    }
    else if([lastRecord.winner isEqualToString:@"Mary Anne"]) {
        self.lastGameResultLabel.text = @"Winner: Mary Anne";
        self.lastGameResultLabel.textColor = [UIColor redColor];
    }
    else {
        self.lastGameResultLabel.text = @"Deadlock";
        self.lastGameResultLabel.textColor = [UIColor sunFlowerFlatColor];
    }
    self.lastGameDateLabel.text = [NSString stringWithFormat:@"Date: %@", [self.dateFormatter stringFromDate:lastRecord.gameTime]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addGameSegue"]) {
        
    }
    else if([segue.identifier isEqualToString:@"viewGameHistorySegue"]) {
        JYJBalloonCupHistoryController *controller = (JYJBalloonCupHistoryController *)segue.destinationViewController;
        controller.model = self.model;
    }
}


@end
