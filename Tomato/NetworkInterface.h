//
//  NetworkInterface.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInterface : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)requestForFoodList;

@end
