//
//  TimeLine.h
//  Tomato
//
//  Created by Cui Hao on 12-11-6.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface TimeLine : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) Food *food;

@end
