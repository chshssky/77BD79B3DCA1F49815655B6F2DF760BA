//
//  PublishHeaderViewController.h
//  Tomato
//
//  Created by 崔 昊 on 12-12-31.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodDetailView.h"

@interface PublishHeaderViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet FoodDetailView *foodDetailView;
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceTextField;

- (IBAction)textFiledReturnEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
