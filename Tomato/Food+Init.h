//
//  Food+Init.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-2.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food.h"

@interface Food (Init)

+ (void)initFood:(NSArray *)foodList inManagedObjectedContext:(NSManagedObjectContext *)context;

@end
