//
//  JYJAppDelegate.h
//  JYJ Helper
//
//  Created by Jason Ji on 10/25/13.
//  Copyright (c) 2013 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
#import "JYJNextBusViewController.h"

@interface JYJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *baseNavController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
