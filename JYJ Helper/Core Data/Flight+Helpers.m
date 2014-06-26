//
//  Flight+Helpers.m
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import "Flight+Helpers.h"

@implementation Flight (Helpers)

+(Flight *)flightWithAirline:(NSString *)airlineCode flightNumber:(NSNumber *)flightNumber originAirportCode:(NSString *)originAirportCode destinationAirportCode:(NSString *)destinationAirportCode departureTime:(NSDate *)departureTime arrivalTime:(NSDate *)arrivalTime storedTimeZone:(NSString *)storedTimeZone inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Flight *flight = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(Flight.class) inManagedObjectContext:managedObjectContext];
    
    flight.airlineCode = airlineCode;
    flight.flightNumber = flightNumber;
    flight.originAirportCode = originAirportCode;
    flight.destinationAirportCode = destinationAirportCode;
    flight.departureTime = departureTime;
    flight.arrivalTime = arrivalTime;
    flight.storedTimeZone = storedTimeZone;
    
    return flight;
}

@end
