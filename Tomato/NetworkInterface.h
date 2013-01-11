//
//  NetworkInterface.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInterface : NSObject

+ (void)requestForFoodListFromID:(NSInteger)min
                            toID:(NSInteger)max
          inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)giveGrade:(NSInteger)foodid
         OldGrade:(NSInteger)oldgrade
         NewGrade:(NSInteger)newgrade;

+(void) PublishFood:(NSString *)name
          foodprice:(NSString *)price
        publishtime:(NSString *)time
        foodimgname:(NSString *)imgname
     restaurantname:(NSString *)restaurantname
           tagsname:(NSString *)tagsname;

+(void) UploadImage:(UIImage *)img
        picturename:(NSString *)picture_name;

+ (NSString *)generateRandomString:(int)length;

+ (void)PublishRestaurant:(NSString *)name
                telephone:(NSString *)tel;

+ (NSArray *)requestForRestaurantList;

+ (void)DownloadImage:(NSString *)imagename;
+ (double)getFoodScore:(int)foodid;

+ (BOOL) isConnectionAvailable;

+ (void)requestForFoodListFromID:(int)min ToID:(int)max Count:(int)count inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)getScoreListFrom:(int)fromid To:(int)toid inManagedObjectContext:(NSManagedObjectContext *)context;

@end
