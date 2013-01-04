//
//  AchievementsTableViewCell.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *achievementImageView;
@property (weak, nonatomic) IBOutlet UILabel *achievementNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementRecordLabel;

@end
