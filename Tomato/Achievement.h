//
//  Achievement.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-5.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Record;

@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSNumber * achievementID;
@property (nonatomic, retain) NSString * achievementImage;
@property (nonatomic, retain) NSString * achievementName;
@property (nonatomic, retain) NSNumber * achievementThreshold;
@property (nonatomic, retain) NSString * achievementDecription;
@property (nonatomic, retain) Record *achievementRecord;

@end
