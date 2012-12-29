//
//  Collection.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-29.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Collection : NSManagedObject

@property (nonatomic, retain) NSNumber * collectionID;
@property (nonatomic, retain) Food *food;

@end
