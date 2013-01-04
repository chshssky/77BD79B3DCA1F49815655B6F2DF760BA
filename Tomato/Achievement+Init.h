//
//  Achievement+Init.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-27.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "Achievement.h"

@interface Achievement (Init)

+ (Achievement *)achievementWithInitialData:(NSString *)achievementName
                                     WithID:(NSInteger)achievementID
                              WithThreshold:(NSInteger)achievementThreshold
                     inManagedObjectContext:(NSManagedObjectContext *)context;


@end
