//
//  Food+ID.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-11.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food.h"

@interface Food (ID)

+(NSInteger)getMaxFoodIDInManagedObjectContext:(NSManagedObjectContext *)context;
+(NSInteger)getMinFoodIDInManagedObjectContext:(NSManagedObjectContext *)context;
+(BOOL)dontHaveMinFoodInManagedObjectContext:(NSManagedObjectContext *)context;

@end
