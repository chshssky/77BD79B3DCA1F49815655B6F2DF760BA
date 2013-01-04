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
#import "Tag+Init.h"
#import "Tag.h"
#import "Record+Food.h"

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
    RateView *rateView = [[RateView alloc] initWithFrame:CGRectMake(80, self.view.frame.size.height-126, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 5;
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
    if (self.whetherTakeout == NO) {
        [self.addToCartButton setHidden:YES];
    }else{
        [self.addToCartButton setHidden:NO];
    }
    
    self.whetherAllowToRate = YES;
    [self setUpEditableRateView:self.whetherAllowToRate];
    
    self.title = self.foodDetail.foodName;
    self.foodPriceLabel.text = [NSString stringWithFormat:@"%.1f",[self.foodDetail.foodPrice floatValue]];
    if (self.foodDetail.collection != nil) {
        self.favoriteButton.enabled = NO;
        [self.favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    Cart *cart = [Cart getCart];
    NSDictionary *food = [Food ConvertFood:self.foodDetail];
    if ([cart.getCartFoodArray containsObject:food]) {
        self.addToCartButton.enabled = NO;
        [self.addToCartButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    self.foodImageView.image = [UIImage imageWithContentsOfFile:[self imageFilePath:self.foodDetail.foodImagePath]];
    self.foodScoreLabelA.text = [NSString stringWithFormat:@"%d",[self.foodDetail.foodScore intValue]];
    int pointNumber = ([self.foodDetail.foodScore floatValue] - [self.foodDetail.foodScore intValue])*10;
    self.foodScoreLabelB.text = [@"." stringByAppendingString:[NSString stringWithFormat:@"%d",pointNumber]];
    
    NSMutableArray *signMutableArray = [[NSMutableArray alloc]initWithArray:[self.foodDetail.tags allObjects]];
    for (int i=0; i<[signMutableArray count]; i++) {
        Tag *foodSign = signMutableArray[i];
        if ([foodSign.tagID intValue] == 5) {
            [signMutableArray removeObjectAtIndex:i];
        }
    }
    if ([signMutableArray count] == 2) {
        Tag *foodSign1 = signMutableArray[0];
        Tag *foodSign2 = signMutableArray[1];
        self.tasteSign.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign1.tagID intValue]]];
        self.junkfoodSign.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign2.tagID intValue]]];
    }else if ([signMutableArray count] == 1) {
        Tag *foodSign1 = signMutableArray[0];
        self.tasteSign.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign1.tagID intValue]]];
    }
}

- (NSString *)getFoodSignImage:(int)foodID{
    NSString *signImageName;
    switch (foodID) {
        case 1:
            signImageName = @"hotSign.png";
            break;
        case 2:
            signImageName = @"brightSign.png";
            break;
        case 3:
            signImageName = @"sweetSign.png";
            break;
        case 4:
            signImageName = @"strangeSign.png";
            break;
        case 6:
            signImageName = @"junkfoodSign.png";
            break;       
        default:
            break;
    }
    return signImageName;
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
    [Record RecordWithFood:self.foodDetail inManagedObjectContext:self.managedObjectContext];
    self.favoriteButton.enabled = NO;
    [self.favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}



@end
