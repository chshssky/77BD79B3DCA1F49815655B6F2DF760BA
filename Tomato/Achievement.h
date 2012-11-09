//
//  Achievement.h
//  Tomato
//
//  Created by Cui Hao on 12-11-9.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSString * name;

@end
