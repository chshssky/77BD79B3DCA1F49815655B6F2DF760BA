//
//  Record+Food.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-4.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Record+Food.h"

@implementation Record (Food)

+ (void)RecordWithFood:(Food *)food
inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *array = [[NSArray alloc] initWithObjects:[food.tags allObjects]];
}

@end
