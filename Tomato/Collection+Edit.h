//
//  Collection+Edit.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-31.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Collection.h"

@interface Collection (Edit)

+ (void)DeleteCollections:(NSArray *)arrays
withFetchedResultController:(NSFetchedResultsController *)frc
    inManagedObjectContext:(NSManagedObjectContext *)context;

@end
