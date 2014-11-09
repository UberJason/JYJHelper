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

@end

@implementation JYJBalloonCupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[JYJBalloonCupModel alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor sunFlowerFlatColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.model refreshCoreData];
    
    NSInteger jasonWins = [self.model numberOfWinsForPlayer:@"Jason"];
    NSInteger makWins = [self.model numberOfWinsForPlayer:@"Mary Anne"];
    
    self.jasonWinLabel.text = [NSString stringWithFormat:@"%ld", jasonWins];
    self.makWinLabel.text = [NSString stringWithFormat:@"%ld", makWins];
    self.tiesLabel.text = [NSString stringWithFormat:@"%ld", [self.model numberOfWinsForPlayer:@"Tie"]];
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
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addGameSegue"]) {
        
    }
    else if([segue.identifier isEqualToString:@"viewGameHistorySegue"]) {
        
    }
}


@end
