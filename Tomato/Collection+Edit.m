//
//  Collection+Edit.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-31.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Collection+Edit.h"

@implementation Collection (Edit)

+ (void)DeleteCollections:(NSArray *)arrays
withFetchedResultController:(NSFetchedResultsController *)frc
   inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSIndexPath *indexPath in arrays) {
        [context deleteObject:[frc objectAtIndexPath:indexPath]];
    }
    NSError *err = nil;
    if (![context save:&err]) {
        NSLog(@"delete collections wrong");
    }
}

@end
