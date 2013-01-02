//
//  Food+Update.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-2.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+Update.h"

@implementation Food (Update)

+ (void)updateFood:(Food *)food
             Score:(NSNumber *)score
inManagedObjectContext:(NSManagedObjectContext *)context
{
    food.foodScore = [NSNumber numberWithFloat:[score floatValue]];
    NSError *err = nil;
    if (![context save:&err]) {
        NSLog(@"Update Food Score Wrong!");
    }

}

@end
