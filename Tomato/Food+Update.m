//
//  Food+Update.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-2.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+Update.h"
#import "TomatoAppDelegate.h"

@implementation Food (Update)

+ (void)updateFood:(Food *)food
             Score:(NSNumber *)score
inManagedObjectContext:(NSManagedObjectContext *)context
{
    food.foodScore = [NSNumber numberWithDouble:[score doubleValue]];
    NSError *err = nil;
    if (![context save:&err]) {
        NSLog(@"Update Food Score Wrong!");
    }

}

+ (void)updateFoodFromID:(NSInteger)min
                    ToID:(NSInteger)max
          WithScoreArray:(NSArray *)scoreArr
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *foodListRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    foodListRequest.predicate = [NSPredicate predicateWithFormat:@"%d <= foodID AND foodID <= %d", min, max];
    foodListRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:YES]];
    NSError *foodError = nil;
    NSArray *foodMatches = [context executeFetchRequest:foodListRequest error:&foodError];
    for (int i = 0; i < [scoreArr count]; i ++) {
        Food *food = [foodMatches objectAtIndex:i];
        NSLog(@"id:%@", [[scoreArr objectAtIndex:i] objectForKey:FOOD_ID]);
        NSLog(@"score:%@", [[scoreArr objectAtIndex:i] objectForKey:FOOD_SCORE]);
        food.foodScore = [NSNumber numberWithDouble:[[[scoreArr objectAtIndex:i] objectForKey:FOOD_SCORE] doubleValue]];
        NSLog(@"foodID : %@ score: %@", food.foodID, food.foodScore);
        
        NSError *err = nil;
        if (![context save:&err]) {
            NSLog(@"Update Food Score Wrong!");
        }
    }
}

@end
