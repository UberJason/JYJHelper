//
//  JYJAddCell.m
//  JYJ Helper
//
//  Created by Jason Ji on 12/28/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJAddCell.h"
#import "JYJTrackingViewController.h"

@implementation JYJAddCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addJasonPressed:(id)sender {
    [self.delegate addJason:self];
}

- (IBAction)addKevinPressed:(id)sender {
    [self.delegate addKevin:self];
}

- (IBAction)deleteSectionPressed:(id)sender {
    [self.delegate deleteSection:self];
}

@end
