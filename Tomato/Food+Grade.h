//
//  Food+Grade.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food.h"

@interface Food (Grade)

+ (void)GiveFood:(Food *)food
          aGrade:(NSInteger)grade
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
