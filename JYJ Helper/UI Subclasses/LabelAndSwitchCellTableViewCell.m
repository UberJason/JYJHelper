//
//  LabelAndSwitchCellTableViewCell.m
//  JYJ Helper
//
//  Created by Jason Ji on 6/9/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "LabelAndSwitchCellTableViewCell.h"

@implementation LabelAndSwitchCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)switchPressed:(id)sender {
    [self.delegate didChangeSwitch:self.control.isOn];
}


@end
