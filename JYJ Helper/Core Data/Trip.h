//
//  Trip.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Trip : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSOrderedSet *flights;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)insertObject:(Flight *)value inFlightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFlightsAtIndex:(NSUInteger)idx;
- (void)insertFlights:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFlightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFlightsAtIndex:(NSUInteger)idx withObject:(Flight *)value;
- (void)replaceFlightsAtIndexes:(NSIndexSet *)indexes withFlights:(NSArray *)values;
- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSOrderedSet *)values;
- (void)removeFlights:(NSOrderedSet *)values;
@end
