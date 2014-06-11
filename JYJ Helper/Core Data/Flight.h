//
//  Flight.h
//  JYJ Helper
//
//  Created by Jason Ji on 6/10/14.
//  Copyright (c) 2014 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trip;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSString * destinationAirportCode;
@property (nonatomic, retain) NSString * originAirportCode;
@property (nonatomic, retain) NSDate * arrivalTime;
@property (nonatomic, retain) NSDate * departureTime;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Trip *trip;

@end
