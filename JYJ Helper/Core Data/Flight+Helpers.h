//
//  Flight+Helpers.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "Flight.h"

@interface Flight (Helpers)

+(Flight *) flightWithAirline:(NSString *)airlineCode flightNumber:(NSNumber *)flightNumber originAirportCode:(NSString *)originAirportCode destinationAirportCode:(NSString *)destinationAirportCode departureTime:(NSDate *)departureTime arrivalTime:(NSDate *)arrivalTime storedTimeZone:(NSString *)storedTimeZone inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
