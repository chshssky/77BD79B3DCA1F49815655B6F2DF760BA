//
//  CartTableViewController.h
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CartTableViewControllerDelegate
- (void) changeAddToCartButtonState;
@end

@interface CartTableViewController : UITableViewController
@property (nonatomic, retain) id<CartTableViewControllerDelegate> delegate;

@end
