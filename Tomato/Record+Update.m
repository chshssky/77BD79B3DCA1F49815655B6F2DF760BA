//
//  Record+Update.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-5.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Record+Update.h"

@implementation Record (Update)


+ (void)RecordWithOrderinManagedObjectContext:(NSManagedObjectContext *)context
{
    Record *record = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    request.predicate = [NSPredicate predicateWithFormat:@"achievements CONTAINS %d", 7];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    record = [matches lastObject];
    int count = [record.recordCount integerValue];
    count ++;
    record.recordCount = [NSNumber numberWithInteger:count];
    if (![context save:&error]) {
        NSLog(@"increase record wrong!");
    }
}

+ (void)RecordWithOpenTimeinManagedObjectContext:(NSManagedObjectContext *)context
{
    Record *record = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    request.predicate = [NSPredicate predicateWithFormat:@"achievements CONTAINS %d", 8];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    record = [matches lastObject];
    int count = [record.recordCount integerValue];
    count ++;
    record.recordCount = [NSNumber numberWithInteger:count];
    if (![context save:&error]) {
        NSLog(@"increase record wrong!");
    }
}

@end
