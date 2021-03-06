//
//  TomatoAppDelegate.m
//  Tomato
//
//  Created by Cui Hao on 12-10-28.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "TomatoAppDelegate.h"
#import <CoreData/CoreData.h>

#import "Tag+Init.h"
#import "Achievement+Init.h"
#import "Record+Update.h"
#import <Parse/Parse.h>

@implementation TomatoAppDelegate

@synthesize preFoodList = _preFoodList;
@synthesize achievements = _achievements;
@synthesize tags = _tags;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

- (NSManagedObjectContext *)managedObjectContext
{
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

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TomatoDataStore.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TomatoDataStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TomatoTest" ofType:@"plist"];
    self.preFoodList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"initialData" ofType:@"plist"];
    NSDictionary *initialData = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSArray *tagsArr = [[NSArray alloc] initWithArray:[initialData objectForKey:TAGS]];
    NSArray *achievementsArr = [[NSArray alloc] initWithArray:[initialData objectForKey:ACHIEVEMENTS]];
    
    self.achievements = tagsArr;
    self.tags = achievementsArr;
    
    NSInteger i = 1;
    for (NSDictionary *tag in tagsArr) {
        [Tag tagWithInitialData:[tag objectForKey:TAG_NAME] andID:i++ andType:[tag objectForKey:TAG_TYPE] inManagedObjectContext:self.managedObjectContext];
    }
    i = 1;
    for (NSDictionary *achievement in achievementsArr) {
        [Achievement achievementWithInitialData:[achievement objectForKey:ACHIEVEMENT_NAME] WithID:i++ WithThreshold:[[achievement objectForKey:ACHIEVEMENT_THRESHOLD] integerValue] WithDescription:[achievement objectForKey:ACHIEVEMENT_DESCRIPTION] inManagedObjectContext:self.managedObjectContext];
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarImage.png"] forBarMetrics:UIBarMetricsDefault];
    
    [Record RecordWithOpenTimeinManagedObjectContext:self.managedObjectContext];
    
    [Parse setApplicationId:@"Wbr5XlZhZh6apUAYOFigqv4oxsZezxOlZs254UIn"
                  clientKey:@"XHsG6Kg5dnHuawdDjd9eT4fqkdrHRxBHYfrdWlyA"];
    
    
    PFObject *initObject = [PFObject objectWithClassName:@"InitObject"];
    [initObject setObject:@"TomatoLaunched" forKey:@"initInfo"];
    [initObject saveInBackground];

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
    [self saveContext];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Returns the URL to the application's Documents directory.

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (TomatoAppDelegate *)getTomatoAppDelegate
{
    return (TomatoAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSArray *)getPreData
{
    return self.preFoodList;
}

- (NSArray *)getFoodTags
{
    return self.tags;
}

@end
