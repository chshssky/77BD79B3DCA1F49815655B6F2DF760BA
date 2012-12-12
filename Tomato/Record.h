//
//  Record.h
//  Tomato
//
//  Created by Cui Hao on 12-12-12.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSNumber * recordCount;
@property (nonatomic, retain) NSSet *achievements;
@end

@interface Record (CoreDataGeneratedAccessors)

- (void)addAchievementsObject:(Achievement *)value;
- (void)removeAchievementsObject:(Achievement *)value;
- (void)addAchievements:(NSSet *)values;
- (void)removeAchievements:(NSSet *)values;

@end
