//
//  Collection+Food.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-29.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Collection.h"

@interface Collection (Food)

+ (Collection *)colletionWithFood:(Food *)food
           inManagedObjectContext:(NSManagedObjectContext *)context;

@end
