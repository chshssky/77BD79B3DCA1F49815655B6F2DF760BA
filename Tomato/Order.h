//
//  Order.h
//  Tomato
//
//  Created by Cui Hao on 12-12-12.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSNumber * orderID;
@property (nonatomic, retain) NSDate * orderTime;
@property (nonatomic, retain) NSSet *foods;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(Food *)value;
- (void)removeFoodsObject:(Food *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

@end
