//
//  Achievement+Init.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-27.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Achievement+Init.h"
#import "Record.h"

@implementation Achievement (Init)

+ (Achievement *)achievementWithInitialData:(NSString *)achievementName
                                     WithID:(NSInteger)achievementID
                              WithThreshold:(NSInteger)achievementThreshold
                     inManagedObjectContext:(NSManagedObjectContext *)context
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
        
        achievement.achievementID = [NSNumber numberWithInteger:achievementID];
        
        Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:context];
        record.recordCount = [NSNumber numberWithInteger:0];
        achievement.achievementRecord = record;
        achievement.achievementName = achievementName;
        achievement.achievementThreshold = [NSNumber numberWithInteger:achievementThreshold];
        
    } else {
        achievement = [matches lastObject];
    }
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return achievement;
}

@end
