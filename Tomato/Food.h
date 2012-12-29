//
//  Food.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-29.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Collection, Order, Restaurant, Tag;

@interface Food : NSManagedObject

@property (nonatomic, retain) NSNumber * foodGrade;
@property (nonatomic, retain) NSNumber * foodID;
@property (nonatomic, retain) NSString * foodImagePath;
@property (nonatomic, retain) NSString * foodName;
@property (nonatomic, retain) NSNumber * foodPrice;
@property (nonatomic, retain) NSDate * foodPublishTime;
@property (nonatomic, retain) NSNumber * foodScore;
@property (nonatomic, retain) Collection *collection;
@property (nonatomic, retain) NSSet *order;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Food (CoreDataGeneratedAccessors)

- (void)addOrderObject:(Order *)value;
- (void)removeOrderObject:(Order *)value;
- (void)addOrder:(NSSet *)values;
- (void)removeOrder:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
