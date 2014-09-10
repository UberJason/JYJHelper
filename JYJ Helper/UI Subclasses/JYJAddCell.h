//
//  JYJAddCell.h
//  JYJ Helper
//
//  Created by Jason Ji on 12/28/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJTrackingViewController;

@interface JYJAddCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addJasonButton;
@property (weak, nonatomic) IBOutlet UIButton *addKevinButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSectionButton;
@property (weak, nonatomic) JYJTrackingViewController *delegate;

@end
