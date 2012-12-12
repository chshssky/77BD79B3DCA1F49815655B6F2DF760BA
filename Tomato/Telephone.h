//
//  Telephone.h
//  Tomato
//
//  Created by Cui Hao on 12-12-12.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurant;

@interface Telephone : NSManagedObject

@property (nonatomic, retain) NSNumber * telephoneID;
@property (nonatomic, retain) NSString * telephoneNumber;
@property (nonatomic, retain) Restaurant *restaurant;

@end
