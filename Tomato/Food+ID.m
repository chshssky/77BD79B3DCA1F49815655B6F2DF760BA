//
//  Food+ID.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-11.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+ID.h"

@implementation Food (ID)

+(NSInteger)getMaxFoodIDInManagedObjectContext:(NSManagedObjectContext *)context
{
//    NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
//    
//
//    foodRequest.predicate = [NSPredicate predicateWithFormat:@"foodID = max"];
//    
//    NSError *foodError = nil;
//    NSArray *foodMatches = [context executeFetchRequest:foodRequest error:&foodError];
    
}

+(NSInteger)getMinFoodIDInManagedObjectContext:(NSManagedObjectContext *)context
{
    
}

+(BOOL)dontHaveMinFoodInManagedObjectContext:(NSManagedObjectContext *)context
{
    
}


@end
