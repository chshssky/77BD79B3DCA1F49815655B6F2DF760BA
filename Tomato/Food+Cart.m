//
//  Food+Cart.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Food+Cart.h"
#import "Telephone.h"
#import "Restaurant.h"
#import "TomatoAppDelegate.h"

@implementation Food (Cart)

+ (NSDictionary *)ConvertFood:(Food *)foodDetail
{
    NSMutableArray *tel = [[NSMutableArray alloc] init];
    
    for (Telephone *telephone in foodDetail.restaurant.telephones) {
        [tel addObject:telephone.telephoneNumber];
    }
    
    NSDictionary *restaurantDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:foodDetail.restaurant.restaurantName, RESTAURANT_NAME, tel, RESTAURANT_TELEPHONE, nil];
    
    NSDictionary *food = [[NSDictionary alloc] initWithObjectsAndKeys:  foodDetail.foodName, FOOD_NAME,
                          [NSString stringWithFormat:@"%@", foodDetail.foodPrice ], FOOD_PRICE,
                          restaurantDictionary, RESTAURANT, nil];
    return food;
}

@end
