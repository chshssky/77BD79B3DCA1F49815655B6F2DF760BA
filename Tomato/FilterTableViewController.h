//
//  FilterTableViewController.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "CoreDataTableViewController.h"

@protocol FilterTableViewControllerDelegate <NSObject>

- (void)sendTheFinalTags:(NSArray *)tagArr andTheFinalRestaurants:(NSArray *)restaurantArr;

-(void)setupFetch;

@end

@interface FilterTableViewController : CoreDataTableViewController

@property (strong, nonatomic) NSMutableArray *tagArray;
@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (weak, nonatomic) id <FilterTableViewControllerDelegate> filterDelegate;

@end
