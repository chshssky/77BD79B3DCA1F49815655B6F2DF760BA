//
//  Achievement.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-26.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSString * achievementImage;
@property (nonatomic, retain) NSString * achievementName;
@property (nonatomic, retain) NSNumber * achievementThreshold;
@property (nonatomic, retain) Record *achievementRecord;

@end
