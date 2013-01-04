//
//  Record+Food.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-4.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Record+Food.h"
#import "Tag.h"

@implementation Record (Food)

+ (void)RecordWithFood:(Food *)food
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Record *record = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Record"];
    NSArray *array = [[NSArray alloc] initWithObjects:[food.tags allObjects], nil];
    for (Tag *tag in array) {
        switch ([tag.tagID integerValue]) {
                case 1:
                request.predicate = [NSPredicate predicateWithFormat:@"achievements CONTAINS %@", tag.tagID];
                NSError *error = nil;
                NSArray *matches = [context executeFetchRequest:request error:&error];
                
                //record =
        }
    }
}

@end
