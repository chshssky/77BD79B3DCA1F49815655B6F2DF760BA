//
//  Record+Food.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-4.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Record.h"
#import "Food.h"

@interface Record (Food)

+ (void)RecordWithFood:(Food *)food
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
