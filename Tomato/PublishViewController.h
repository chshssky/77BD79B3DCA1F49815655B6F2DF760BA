//
//  PublishViewController.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *foodImageButton;

@end
