//
//  GameRecord+Helpers.h
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "GameRecord.h"

@interface GameRecord (Helpers)

+(GameRecord *)gameRecordWithWinner:(NSString *)winner numWinnerCups:(NSInteger)numWinnerCups numLoserCups:(NSInteger)numLoserCups gameTime:(NSDate *)gameTime inManagedObjectContext:(NSManagedObjectContext *)context;

@end
