//
//  Cart.h
//  Tomato
//
//  Created by xsource on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cart : NSObject
+ (Cart *)getCart;
- (void)addToCartFoodArray:(NSDictionary *)cartFood;
- (NSMutableArray *)getCartFoodArray;
- (NSMutableArray *)getRestaurantNameArray;
- (int)getRestaurantFoodCount:(int)index_section;
- (NSString *)getRestaurantFoodNameAndPriceAtSection:(int)index_section AtRow:(int)index_row NameOrPrice:(NSString *)key;
- (NSString *)getTheRestaurantSumPriceAtSection:(int)indexPath_section;
- (void)deleteRestaurantFoodAtSection:(int)index_section AtRow:(int)index_row;
- (int)getRestaurantNameCount;
- (NSString *)getRestaurantName:(int)index_section;
- (NSString *)getRestaurantTelephoneNumber:(int)index_section;
@end
