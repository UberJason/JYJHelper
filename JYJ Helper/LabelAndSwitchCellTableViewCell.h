//
//  LabelAndSwitchCellTableViewCell.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/9/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>

-(void)didChangeSwitch:(BOOL)selected;

@end

@interface LabelAndSwitchCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *label;
@property (weak, nonatomic) IBOutlet UISwitch *control;
@property (weak, nonatomic) UIViewController<SwitchCellDelegate> *delegate;

@end
