//
//  Trip+Helpers.m
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "Trip+Helpers.h"

@implementation Trip (Helpers)

+(instancetype)tripWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Trip *trip = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self.class) inManagedObjectContext:managedObjectContext];
    
    trip.name = name;
    trip.startDate = startDate;
    trip.endDate = endDate;
    
    return trip;
}

@end
