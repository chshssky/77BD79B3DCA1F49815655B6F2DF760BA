//
//  Collection+Food.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-29.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Collection+Food.h"
#import "Food.h"

@implementation Collection (Food)

+ (Collection *)colletionWithFood:(Food *)food
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    Collection *collection = nil;
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Collection"];
//    request.predicate = [NSPredicate predicateWithFormat:@"CollectionID = %@", collectionID];
//    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor ]
    
    NSError *error = nil;
//    NSArray *matches = [context executeFetchRequest:request error:&error];
//    
//    if (!matches || ([matches count] > 1)) {
//        NSLog(@"Init Collections Wrong!");
//    } else if ([matches count] == 0) {

        collection = [NSEntityDescription insertNewObjectForEntityForName:@"Collection" inManagedObjectContext:context];
        collection.CollectionID = [NSNumber numberWithUnsignedInt:0];
        collection.food = food;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
//    } else {
//        collection = [matches lastObject];
//    }
    
    return collection;
}

@end
