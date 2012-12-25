//
//  FoodTomatoTableViewCell.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTomatoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodGradeLabel;

@end