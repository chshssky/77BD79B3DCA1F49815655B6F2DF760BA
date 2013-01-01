//
//  NetworkInterface.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInterface : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)requestForFoodListFromID:(NSInteger) min toID:(NSInteger) max;
- (void)giveFood:(NSInteger)foodID aGrade:(NSInteger)foodGrade;

+(void) PublishFood:(NSString *)name foodprice:(NSString *)price publishtime:(NSString *)time foodimgname:(NSString *)imgname restaurantname:(NSString *)restaurantname tagsname:(NSString *)tagsname;
+(void) UploadImage:(UIImage *)img picturename:(NSString *)picture_name;

+ (NSString *)generateRandomString :(int)length;
+ (void)PublishRestaurant:(NSString *)name telephone:(NSString *)tel;

@end
