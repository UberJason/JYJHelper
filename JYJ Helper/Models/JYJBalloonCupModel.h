//
//  JYJBalloonCupModel.h
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRecord+Helpers.h"
@interface JYJBalloonCupModel : NSObject

@property (strong, nonatomic) NSArray *gameRecords;

-(void)refreshCoreData;
-(NSInteger)numberOfWinsForPlayer:(NSString *)player;
-(GameRecord *)mostRecentGameRecord;

@end
