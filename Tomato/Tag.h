//
//  Tag.h
//  Tomato
//
//  Created by Cui Hao on 12-11-9.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *foods;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(Food *)value;
- (void)removeFoodsObject:(Food *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

@end
