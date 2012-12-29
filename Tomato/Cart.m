//
//  Cart.m
//  Tomato
//
//  Created by xsource on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Cart.h"
#import "TomatoAppDelegate.h"

@interface Cart()
@property (nonatomic, strong) NSMutableArray *cartFoodArray;

@end;

@implementation Cart
@synthesize cartFoodArray = _cartFoodArray;
static Cart *cart = nil;


+ (Cart *)getCart
{
    if (cart == nil) {
        cart = [[self alloc] init];
    }
    return cart;
}

- (void)addToCartFoodArray:(NSDictionary *)cartFood
{
    if (_cartFoodArray == nil) {
        self.cartFoodArray = [[NSMutableArray alloc] init];
    }
    
    [self.cartFoodArray addObject:cartFood];
    
}

- (NSMutableArray *)getCartFoodArray
{
    if (_cartFoodArray == nil) {
        _cartFoodArray = [[NSMutableArray alloc] init];
    }
    return _cartFoodArray;
}

- (NSMutableArray *)getRestaurantNameArray
{
    
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    return restaurantNameArray;
}

- (int)getRestaurantNameCount
{
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    int restaurantNameCount = [restaurantNameArray count];
    return restaurantNameCount;
}

-(int)getRestaurantFoodCount:(int)index_section
{
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    int restaurantFoodCount = 0;
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (restaurantName == restaurantNameArray[index_section]) {
            restaurantFoodCount++;
        }
    }
    
    return restaurantFoodCount;
}

- (NSString *)getRestaurantName:(int)index_section
{
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    NSString *restaurantName = restaurantNameArray[index_section];
    return restaurantName;
}

- (NSString *)getRestaurantFoodNameAndPriceAtSection:(int)index_section AtRow:(int)index_row NameOrPrice:(NSString *)key
{
    NSMutableArray *restaurantFoodNameAndPriceArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    
    NSString *RestaurantNameToShow = restaurantNameArray[index_section];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (RestaurantNameToShow == restaurantName) {
            if (key == @"Price") {
                [restaurantFoodNameAndPriceArray addObject:[index objectForKey:FOOD_PRICE]];
            }else{
               [restaurantFoodNameAndPriceArray addObject:[index objectForKey:FOOD_NAME]];
            }
        }
    }
    if (index_row < restaurantFoodNameAndPriceArray.count) {
        return restaurantFoodNameAndPriceArray[index_row];
    }
    else{
        return nil;
    }
}

- (NSString *)getTheRestaurantSumPriceAtSection:(int)index_section
{
    float sumPrice = 0;
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    
    NSString *targetRestaurantName = restaurantNameArray[index_section];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (targetRestaurantName == restaurantName) {
            NSString *price = [index objectForKey:FOOD_PRICE];
            sumPrice += [price intValue];
        }
    }
    NSString *sumPriceText =[NSString stringWithFormat:@"%.1f",sumPrice];
    return sumPriceText;
}

- (void)deleteRestaurantFoodAtSection:(int)index_section AtRow:(int)index_row
{
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
        }
    }
    
    NSString *restaurantNameToDelete = restaurantNameArray[index_section];
    
    NSMutableArray *restaurantFoodNameToDeleteArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        if (restaurantNameToDelete == restaurantName) {
            [restaurantFoodNameToDeleteArray addObject:[index objectForKey:FOOD_NAME]];
        }
    }
    NSString *restaurantFoodNameToDelete = restaurantFoodNameToDeleteArray[index_row];
    
    int k = 0;
    for (int i=0; i<self.cartFoodArray.count; i++) {
        NSDictionary *index = self.cartFoodArray[i];
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];
        NSString *foodName = [index objectForKey:FOOD_NAME];
        if (foodName == restaurantFoodNameToDelete && restaurantName == restaurantNameToDelete) {
            k = i;
            [self.cartFoodArray removeObjectAtIndex:i];
        }
    }
}

- (NSString *)getRestaurantTelephoneNumber:(int)index_section
{
    NSMutableArray *restaurantNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *restauranTelephoneNumberArray = [[NSMutableArray alloc] init];
    for (NSDictionary *index in self.cartFoodArray) {
        NSString *restaurantName = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_NAME];     
        NSArray *TelephoneNumbers = [[index objectForKey:RESTAURANT] objectForKey:RESTAURANT_TELEPHONE];
        if (![restaurantNameArray containsObject:restaurantName]) {
            [restaurantNameArray addObject:restaurantName];
            [restauranTelephoneNumberArray addObject:TelephoneNumbers[0]];
        }
    }
    
    NSString *restaurantTelephoneNumber = restauranTelephoneNumberArray[index_section];
    return restaurantTelephoneNumber;
}


















@end
