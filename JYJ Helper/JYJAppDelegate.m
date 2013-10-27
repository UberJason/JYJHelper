//
//  JYJAppDelegate.m
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJAppDelegate.h"

#define DEFAULT_MIN_MORNING_HOUR 6
#define DEFAULT_MAX_MORNING_HOUR 8
#define DEFAULT_MIN_AFTERNOON_HOUR 14
#define DEFAULT_MAX_AFTERNOON_HOUR 18

@interface JYJAppDelegate ()

@property (nonatomic) NSInteger minMorningHour;
@property (nonatomic) NSInteger maxMorningHour;
@property (nonatomic) NSInteger minAfternoonHour;
@property (nonatomic) NSInteger maxAfternoonHour;

@property (strong, nonatomic) NSDateComponents *currentDateComponents;

@end

@implementation JYJAppDelegate

-(NSDateComponents *)currentDateComponents {
    if(!_currentDateComponents) {
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _currentDateComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:today];
        
    }
    
    return _currentDateComponents;
}

-(UINavigationController *)baseNavController {
    if(!_baseNavController)
        _baseNavController = [[UINavigationController alloc] init];
    
    return _baseNavController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setMorningAndAfternoonRanges];
    
    if([self isWeekday:[self.currentDateComponents weekday]] && ([self isMorning:[self.currentDateComponents hour]] || [self isAfternoon:[self.currentDateComponents hour]])) {
        JYJNextBusViewController *webView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webView"];
        webView.homeRequested = [self isMorning:[self.currentDateComponents hour]];
        [self.window makeKeyAndVisible];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:webView animated:YES completion:nil];
        });
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - helper methods


-(void)setMorningAndAfternoonRanges {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults integerForKey:@"minMorningHour"])
        self.minMorningHour = [defaults integerForKey:@"minMorningHour"];
    else
        self.minMorningHour = DEFAULT_MIN_MORNING_HOUR;
    
    if([defaults integerForKey:@"maxMorningHour"])
        self.maxMorningHour = [defaults integerForKey:@"maxMorningHour"];
    else
        self.maxMorningHour = DEFAULT_MAX_MORNING_HOUR;
    
    if([defaults integerForKey:@"minAfternoonHour"])
        self.minAfternoonHour = [defaults integerForKey:@"minAfternoonHour"];
    else
        self.minAfternoonHour = DEFAULT_MIN_AFTERNOON_HOUR;
    
    if([defaults integerForKey:@"maxAfternoonHour"])
        self.maxAfternoonHour = [defaults integerForKey:@"maxAfternoonHour"];
    else
        self.maxAfternoonHour = DEFAULT_MAX_AFTERNOON_HOUR;
}

-(BOOL)isWeekday:(NSInteger)dayOfWeek {
    return !(dayOfWeek == 1 || dayOfWeek == 7);
}

-(BOOL)isMorning:(NSInteger)hour {
    return hour >= self.minMorningHour && hour <= self.maxMorningHour;
}

-(BOOL)isAfternoon:(NSInteger)hour {
    return hour >= self.minAfternoonHour && hour <= self.maxAfternoonHour;
}

@end
