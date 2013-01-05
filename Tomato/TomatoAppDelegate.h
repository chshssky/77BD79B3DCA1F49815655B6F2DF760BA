//
//  TomatoAppDelegate.h
//  Tomato
//
//  Created by Cui Hao on 12-10-28.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FOOD_NAME @"名称"
#define FOOD_SCORE @"评分"
#define FOOD_TAGS @"美食标签"
#define FOOD_PRICE @"价格"
#define FOOD_IMAGE_PATH @"图片"
#define FOOD_UPLOAD_TIME @"上传时间"

#define RESTAURANT @"餐馆"
#define RESTAURANT_NAME @"名称"
#define RESTAURANT_TELEPHONE @"电话"
#define RESTAURANT_ID @"餐馆ID"

#define TAGS @"标签"

#define TAG_NAME @"标签名称"
#define TAG_TYPE @"标签种类"
#define TAG_IMAGE_PATH @"标签图片路径"

#define ACHIEVEMENTS @"成就"

#define ACHIEVEMENT_NAME @"成就名称"
#define ACHIEVEMENT_THRESHOLD @"成就阈值"
#define ACHIEVEMENT_IMAGE_PATH @"成就图片路径"
#define ACHIEVEMENT_DESCRIPTION @"成就描述"



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
- (TomatoAppDelegate *)getTomatoAppDelegate;

@end
