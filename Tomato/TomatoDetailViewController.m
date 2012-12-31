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
#import "CartTableViewController.h"
#import "Food+Cart.h"
#import "Cart.h"

@interface TomatoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@end

@implementation TomatoDetailViewController
@synthesize foodDetail = _foodDetail;
@synthesize foodPriceLabel = _foodPriceLabel;
@synthesize foodImageView = _foodImageView;
@synthesize foodTagLabel = _foodTagLabel;
@synthesize favoriteButton = _favoriteButton;
@synthesize addToCartButton = _addToCartButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.foodDetail.collection == nil) {
        self.favoriteButton.enabled = YES;
        [self.favoriteButton setTitleColor:[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1] forState:UIControlStateNormal];
    }
    Cart *cart = [Cart getCart];
    NSDictionary *food = [Food ConvertFood:self.foodDetail];
    if (![cart.getCartFoodArray containsObject:food]) {
        self.addToCartButton.enabled = YES;
        [self.addToCartButton setTitleColor:[UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.foodDetail.foodName;
    self.foodPriceLabel.text = [NSString stringWithFormat:@"%@",self.foodDetail.foodPrice];
    if (self.foodDetail.collection != nil) {
        self.favoriteButton.enabled = NO;
        [self.favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    Cart *cart = [Cart getCart];
    NSDictionary *food = [Food ConvertFood:self.foodDetail];
    if ([cart.getCartFoodArray containsObject:food]) {
        self.addToCartButton.enabled = NO;
        NSLog(@"%@",self.addToCartButton.titleLabel.textColor);
        [self.addToCartButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    // configure the other detail here...
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddToChart:(id)sender {
    Cart *cart = [Cart getCart];
    NSDictionary *food = [Food ConvertFood:self.foodDetail];
    [cart addToCartFoodArray:food];
    self.addToCartButton.enabled = NO;
    [self.addToCartButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
}

- (IBAction)AddToFavorite:(id)sender {
    [Collection colletionWithFood:self.foodDetail inManagedObjectContext:self.managedObjectContext];
    self.favoriteButton.enabled = NO;
    [self.favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

- (IBAction)grade:(id)sender {
    
}


@end
