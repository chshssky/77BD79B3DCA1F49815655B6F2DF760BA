//
//  Tag+Init.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Tag+Init.h"

@implementation Tag (Init)

+ (Tag *)tagWithInitialData:(NSString *)tagName
                      andID:(NSInteger)index
                    andType:(NSString *)tagType
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"tagID = %d", index];
    //NSSortDescriptor *sortDescriptor = [NSSortDescriptor ]
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Init Tags Wrong!");
    } else if ([matches count] == 0) {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.tagID = [NSNumber numberWithUnsignedInt:index];
        tag.tagName = tagName;
        tag.tagType = tagType;
    } else {
        tag = [matches lastObject];
    }
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return tag;
}
@end
