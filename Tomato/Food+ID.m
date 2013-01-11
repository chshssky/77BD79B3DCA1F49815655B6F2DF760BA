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
    NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    
    foodRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:NO]];
    [foodRequest setFetchLimit:1];
    NSError *foodError = nil;
    NSArray *foodMatches = [context executeFetchRequest:foodRequest error:&foodError];
    
    Food *food = [foodMatches lastObject];
    NSLog(@"foodID Max: %@", food.foodID);
    return [food.foodID integerValue];
}

+(NSInteger)getMinFoodIDInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    
    foodRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:YES]];
    [foodRequest setFetchLimit:1];
    NSError *foodError = nil;
    NSArray *foodMatches = [context executeFetchRequest:foodRequest error:&foodError];
    Food *food = [foodMatches lastObject];
    NSLog(@"foodID Min: %@", food.foodID);
    return [food.foodID integerValue];
}

+(BOOL)dontHaveMinFoodInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    
    foodRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:YES]];
    [foodRequest setFetchLimit:1];
    NSError *foodError = nil;
    NSArray *foodMatches = [context executeFetchRequest:foodRequest error:&foodError];
    Food *food = [foodMatches lastObject];
    BOOL donthasMinFood = ![food.foodID isEqualToNumber:[NSNumber numberWithInt:1]];
    NSLog(@"dont have Min: %@", donthasMinFood? @"YES" : @"NO");
    return donthasMinFood;
}


@end
