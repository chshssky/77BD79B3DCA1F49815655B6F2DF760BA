//
//  Achievement+Init.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-27.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Achievement.h"

@interface Achievement (Init)

+ (void)achievementWithInitialData:(NSString *)achievementName
    inManagedObjectContext:(NSManagedObjectContext *)context;


@end
