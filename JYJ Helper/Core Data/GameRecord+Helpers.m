//
//  GameRecord+Helpers.m
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "GameRecord+Helpers.h"

@implementation GameRecord (Helpers)

+(GameRecord *)gameRecordWithWinner:(NSString *)winner numWinnerCups:(NSInteger)numWinnerCups numLoserCups:(NSInteger)numLoserCups gameTime:(NSDate *)gameTime inManagedObjectContext:(NSManagedObjectContext *)context {
    GameRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"GameRecord" inManagedObjectContext:context];
    
    record.winner = winner;
    record.numWinnerCups = @(numWinnerCups);
    record.numLoserCups = @(numLoserCups);
    record.gameTime = gameTime;
    
    return record;
}

@end
