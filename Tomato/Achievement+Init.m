//
//  Achievement+Init.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-27.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Achievement+Init.h"

@implementation Achievement (Init)

+ (void)achievementWithInitialData:(NSString *)achievementName
            inManagedObjectContext:(NSManagedObjectContext *)context;
{
    Achievement *achievement = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Achievement"];
    request.predicate = [NSPredicate predicateWithFormat:@"achievementName = %@", achievementName];
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor ]
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Init Achievements Wrong!");
    } else if ([matches count] == 0) {
        achievement = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:context];
        achievement.achievementName = achievementName;
        //achieveEntity.achievementThreshold = [NSNumber numberWithUnsignedInt:0];
        
    } else {
        achievement = [matches lastObject];
    }
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    //return achievement;
}

@end
