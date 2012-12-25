//
//  TomatoAppDelegate.h
//  Tomato
//
//  Created by Cui Hao on 12-10-28.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TomatoAppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *preFoodList;
    NSArray *achievements;
    NSArray *tags;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *preFoodList;
@property (strong, nonatomic) NSArray *achievements;
@property (strong, nonatomic) NSArray *tags;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;


- (NSArray *)getPreFoodList;
- (NSArray *)getFoodTags;

@end
