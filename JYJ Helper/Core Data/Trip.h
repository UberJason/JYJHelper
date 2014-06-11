//
//  Trip.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trip : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet *flights;
@end

@interface Trip (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(NSManagedObject *)value;
- (void)removeFlightsObject:(NSManagedObject *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

@end
