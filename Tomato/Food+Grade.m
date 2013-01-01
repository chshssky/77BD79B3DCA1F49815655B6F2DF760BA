//
//  Food+Grade.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+Grade.h"

@implementation Food (Grade)

+ (void)GiveFood:(Food *)food
          aGrade:(NSInteger)grade
inManagedObjectContext:(NSManagedObjectContext *)context
{
    food.foodGrade = [NSNumber numberWithInteger:grade];
    NSError *err = nil;
    if (![context save:&err]) {
        NSLog(@"Update Food Grade Wrong!");
    }
}

@end
