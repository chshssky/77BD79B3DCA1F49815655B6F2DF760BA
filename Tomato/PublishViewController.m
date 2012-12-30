//
//  PublishViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "PublishViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController
@synthesize foodImageView = _foodImageView;
@synthesize foodNameTextField = _foodNameTextField;
@synthesize foodPriceTextField = _foodPriceTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)completeButtonPushed:(id)sender {
    NSLog(@"%@ %@", self.foodNameTextField.text, self.foodPriceTextField.text);
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
    //    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    //
    //    NSString *path = [NetworkInterface generateRandomString:15];
    //    [NetworkInterface PublishFood:@"foodName" foodprice:@"8.0" publishtime:@"2012-10-20 23:20:19" foodimgname:path restaurantname:@"KFC" tagsname:@"1&4&6"];
    //    [NetworkInterface UploadImage:image picturename:path];
}

@end
