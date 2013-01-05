//
//  Record+Update.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-5.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Record.h"

@interface Record (Update)

+ (void)RecordWithOrderinManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)RecordWithOpenTimeinManagedObjectContext:(NSManagedObjectContext *)context;


@end
