//
//  TomatoDetailViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "TomatoDetailViewController.h"

@interface TomatoDetailViewController ()

@end

@implementation TomatoDetailViewController
@synthesize foodDetail = _foodDetail;
@synthesize foodPriceLabel = _foodPriceLabel;
@synthesize foodImageView = _foodImageView;
@synthesize foodTagLabel = _foodTagLabel;

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
    self.title = [self.foodDetail objectForKey:@"名称"];
    self.foodPriceLabel.text = [self.foodDetail objectForKey:@"价格"];
    // configure the other detail here...
    //l;kjl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddToChart:(id)sender {
    
}

- (IBAction)AddToFavorite:(id)sender {
    
}

- (IBAction)grade:(id)sender {
    
}


@end
