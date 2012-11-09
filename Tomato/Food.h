//
//  Food.h
//  Tomato
//
//  Created by Cui Hao on 12-11-9.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Collection, Grade, Order, Restaurant, Tag, TimeLine;

@interface Food : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Collection *collection;
@property (nonatomic, retain) Grade *like;
@property (nonatomic, retain) NSSet *order;
@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) TimeLine *timeLine;
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
