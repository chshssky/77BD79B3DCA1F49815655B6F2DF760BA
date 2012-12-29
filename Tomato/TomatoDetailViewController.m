//
//  TomatoDetailViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "TomatoDetailViewController.h"
#import "TomatoAppDelegate.h"
#import "Collection+Food.h"

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
    self.title = self.foodDetail.foodName;
    self.foodPriceLabel.text = [NSString stringWithFormat:@"%@",self.foodDetail.foodPrice];
    // configure the other detail here...
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddToChart:(id)sender {
    
}

- (IBAction)AddToFavorite:(id)sender {
    [Collection colletionWithFood:self.foodDetail inManagedObjectContext:self.managedObjectContext];
}

- (IBAction)grade:(id)sender {
    
}


@end
