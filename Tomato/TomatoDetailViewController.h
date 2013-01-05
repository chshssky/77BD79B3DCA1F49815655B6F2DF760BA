//
//  TomatoDetailViewController.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "CoreDataViewController.h"
#import "RateView.h"

@protocol TomatoDetailViewControllerDelegate <NSObject>

- (void)requestForFoodScore:(Food *)food;

@end

@interface TomatoDetailViewController : CoreDataViewController <RateViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodPriceLabel;
@property (strong, nonatomic) Food *foodDetail;
@property (nonatomic) BOOL whetherTakeout;
@property (weak, nonatomic) IBOutlet UILabel *foodScoreLabelA;
@property (weak, nonatomic) IBOutlet UILabel *foodScoreLabelB;
@property (weak, nonatomic) IBOutlet UIImageView *tasteSign;
@property (weak, nonatomic) IBOutlet UIImageView *junkfoodSign;

@property (weak, nonatomic) IBOutlet id <TomatoDetailViewControllerDelegate> detailDelegate;

@end
