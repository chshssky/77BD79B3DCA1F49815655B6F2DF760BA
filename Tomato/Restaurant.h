//
//  Restaurant.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food, Telephone;

@interface Restaurant : NSManagedObject

@property (nonatomic, retain) NSNumber * restaurantID;
@property (nonatomic, retain) NSString * restaurantName;
@property (nonatomic, retain) NSSet *foods;
@property (nonatomic, retain) NSSet *telephones;
@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(Food *)value;
- (void)removeFoodsObject:(Food *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

- (void)addTelephonesObject:(Telephone *)value;
- (void)removeTelephonesObject:(Telephone *)value;
- (void)addTelephones:(NSSet *)values;
- (void)removeTelephones:(NSSet *)values;

@end
