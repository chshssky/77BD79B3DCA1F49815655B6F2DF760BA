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
#import "Cart.h"
#import "Restaurant.h"
#import "Telephone.h"

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
    Cart *cart = [Cart getCart];
    
    NSMutableArray *tel = [[NSMutableArray alloc] init];
    
    for (Telephone *telephone in self.foodDetail.restaurant.telephones) {
        [tel addObject:telephone.telephoneNumber];
    }
    
    NSDictionary *restaurantDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.foodDetail.restaurant.restaurantName, RESTAURANT_NAME, tel, RESTAURANT_TELEPHONE, nil];
    
    NSDictionary *food = [[NSDictionary alloc] initWithObjectsAndKeys:  self.foodDetail.foodName, FOOD_NAME,
                                                                        [NSString stringWithFormat:@"%@", self.foodDetail.foodPrice ], FOOD_PRICE,
                                                                        restaurantDictionary, RESTAURANT, nil];
    NSLog(@"%@",[[food objectForKey:RESTAURANT] objectForKey:RESTAURANT_TELEPHONE]);
    if ([cart.getCartFoodArray containsObject:food]) {
        return;
    }
    [cart addToCartFoodArray:food];
}

- (IBAction)AddToFavorite:(id)sender {
    [Collection colletionWithFood:self.foodDetail inManagedObjectContext:self.managedObjectContext];
}

- (IBAction)grade:(id)sender {
    
}


@end
