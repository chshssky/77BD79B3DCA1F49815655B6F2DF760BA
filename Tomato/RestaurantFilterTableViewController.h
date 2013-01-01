//
//  RestaurantFilterTableViewController.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@protocol RestaurantFilterTableViewControllerDelegate <NSObject>

- (void)sendTheFinalRestaurantArray:(NSMutableArray *)restaurantsArr;

@end

@interface RestaurantFilterTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSMutableArray *restaurantArray;
@property (nonatomic, weak) id <RestaurantFilterTableViewControllerDelegate> restDelegate;

@end
