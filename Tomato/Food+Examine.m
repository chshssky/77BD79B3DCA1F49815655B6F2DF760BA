//
//  Food+Examine.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-9.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+Examine.h"

@implementation Food (Examine)

+ (BOOL)IsTheLastFood:(Food *)food
{
    if ([food.foodID isEqualToNumber:[NSNumber numberWithInt:1]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
