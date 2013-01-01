//
//  RestaurantTableViewController.h
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestaurantTableViewControllerDelegate <NSObject>

- (void)sendTheSelectedRestaurantIndex:(NSInteger)index;
- (void)sendTheAddedTelephoneNumber:(NSString *)telephoneNumber;
- (void)sendTheAddedRestaurantName:(NSString *)restaurantName;

@end


@interface RestaurantTableViewController : UITableViewController

@property (nonatomic, strong) NSString *deliveredTitle;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *restName;

@property (nonatomic, weak) IBOutlet id <RestaurantTableViewControllerDelegate> restaurantDelegate;

@end
