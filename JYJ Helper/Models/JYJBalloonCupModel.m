//
//  JYJBalloonCupModel.m
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "JYJBalloonCupModel.h"

@implementation JYJBalloonCupModel

-(instancetype)init {
    self = [super init];
    if(self) {
        [self refreshCoreData];
    }
    return self;
}

-(NSInteger)numberOfWinsForPlayer:(NSString *)player {
    NSArray *filteredRecords = [self.gameRecords filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.winner == %@", player]];
    return filteredRecords.count;
}

-(void)refreshCoreData {
    NSManagedObjectContext *context = ((JYJAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameRecord"];
    self.gameRecords = [context executeFetchRequest:request error:nil];
}
@end
