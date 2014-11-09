//
//  GameRecord.h
//  JYJ Helper
//
//  Created by Jason Ji on 11/8/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GameRecord : NSManagedObject

@property (nonatomic, retain) NSString * winner;
@property (nonatomic, retain) NSDate * gameTime;
@property (nonatomic, retain) NSNumber * numWinnerCups;
@property (nonatomic, retain) NSNumber * numLoserCups;

@end
