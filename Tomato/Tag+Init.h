//
//  Tag+Init.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Tag.h"

@interface Tag (Init)

+ (void)tagWithInitialData:(NSString *)tagName
                      andID:(NSInteger)index
     inManagedObjectContext:(NSManagedObjectContext *)context;

@end
