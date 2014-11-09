//
//  JYJAppDelegate.m
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import "JYJAppDelegate.h"

#define DEFAULT_MIN_MORNING_HOUR 6
#define DEFAULT_MAX_MORNING_HOUR 9
#define DEFAULT_MIN_AFTERNOON_HOUR 15
#define DEFAULT_MAX_AFTERNOON_HOUR 18

@interface JYJAppDelegate ()

@property (nonatomic) NSInteger minMorningHour;
@property (nonatomic) NSInteger maxMorningHour;
@property (nonatomic) NSInteger minAfternoonHour;
@property (nonatomic) NSInteger maxAfternoonHour;

@property (strong, nonatomic) NSDateComponents *currentDateComponents;

@end

@implementation JYJAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    // A hack to quickly set a value for bool key if it exists - value is stored internally as NSNumber
    // http://stackoverflow.com/questions/9971811/how-do-i-test-if-bool-exists-in-nsuserdefaults-user-settings
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"autoShowBus"])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoShowBus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoShowBus"]) {
        [self setMorningAndAfternoonRanges];
        
        if([self isWeekday:[self.currentDateComponents weekday]] && ([self isMorning:[self.currentDateComponents hour]] || [self isAfternoon:[self.currentDateComponents hour]])) {
            JYJNextBusViewController *webView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webView"];
            webView.homeRequested = [self isMorning:[self.currentDateComponents hour]] ? BusSelectedHome23T : BusSelectedWork;
            [self.window makeKeyAndVisible];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.window.rootViewController presentViewController:webView animated:YES completion:nil];
            });
        }
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
    
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JYJ_Helper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JYJ_Helper.sqlite"];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
