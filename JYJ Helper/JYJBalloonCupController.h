//
//  JYJBalloonCupController.h
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJBalloonCupModel.h"

@interface JYJBalloonCupController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *jasonWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *makWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewGameHistoryButton;
@property (weak, nonatomic) IBOutlet UIView *overallPanel;

@property (weak, nonatomic) IBOutlet UILabel *lastGameResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastGameDateLabel;

@end
