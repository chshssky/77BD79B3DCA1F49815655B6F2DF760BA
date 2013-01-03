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
#import "Food+Grade.h"
#import "Cart.h"
#import "NetworkInterface.h"

@interface TomatoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (nonatomic) BOOL whetherAllowToRate;
@property (nonatomic) NSInteger rateScore;
- (void)setUpEditableRateView:(BOOL)whetherAllowToRate;
@end

@implementation TomatoDetailViewController
@synthesize whetherAllowToRate = _whetherAllowToRate;
@synthesize rateScore = _rateScore;
@synthesize foodDetail = _foodDetail;
@synthesize foodPriceLabel = _foodPriceLabel;
@synthesize foodImageView = _foodImageView;
@synthesize foodTagLabel = _foodTagLabel;
@synthesize favoriteButton = _favoriteButton;
@synthesize addToCartButton = _addToCartButton;

- (void)setUpEditableRateView:(BOOL)whetherAllowToRate{
    RateView *rateView = [[RateView alloc] initWithFrame:CGRectMake(70, 330, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 10;
    rateView.rate = [self.foodDetail.foodGrade floatValue]/2;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = whetherAllowToRate;
    rateView.delegate = self;
    [self.view addSubview:rateView];
}

- (void)rateView:(RateView *)rateView changedToNewRate:(NSNumber *)rate
{
    _rateScore = [rate intValue];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //推出时提交评分，并且把评分存入数据库
    if (self.rateScore != 0) {
        NSLog(@"main thread begin...");
        [self performSelectorInBackground:@selector(doSomething:) withObject:nil];
        NSLog(@"main thread end.....");
//        dispatch_queue_t fetchQ = dispatch_queue_create("Upload Grade Thread", NULL);
//        dispatch_async(fetchQ, ^{
//            [NetworkInterface giveGrade:[self.foodDetail.foodID integerValue] OldGrade:[self.foodDetail.foodGrade integerValue] NewGrade:self.rateScore];
//            [Food GiveFood:self.foodDetail aGrade:self.rateScore inManagedObjectContext:self.managedObjectContext];
//            
//        });
    }
}

- (void) doSomething:(id)sender
{
    NSLog( @"one thread begin..." );
    [NetworkInterface giveGrade:[self.foodDetail.foodID integerValue] OldGrade:[self.foodDetail.foodGrade integerValue] NewGrade:self.rateScore];
    NSLog(@"old:grade:%@", self.foodDetail.foodGrade);
    NSLog(@"new:grade:%d", self.rateScore);
    [Food GiveFood:self.foodDetail aGrade:self.rateScore inManagedObjectContext:self.managedObjectContext];
    NSLog( @"one thread end..." );
}
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
    
    self.whetherAllowToRate = YES;
    [self setUpEditableRateView:self.whetherAllowToRate];
    
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
//    dispatch_queue_t loadImage_queue;
//    loadImage_queue = dispatch_queue_create("network_queue", nil);
//    dispatch_async(loadImage_queue, ^{
        self.foodImageView.image = [UIImage imageWithContentsOfFile:[self imageFilePath:self.foodDetail.foodImagePath]];
//    });
}

- (NSString *)imageFilePath:(NSString *)imageName
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:@"jpg"]];
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



@end
