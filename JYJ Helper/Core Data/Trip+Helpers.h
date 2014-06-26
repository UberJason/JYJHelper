//
//  Trip+Helpers.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "Trip.h"

@interface Trip (Helpers)

+(Trip *)tripWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate storedTimeZone:(NSString *)storedTimeZone inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
