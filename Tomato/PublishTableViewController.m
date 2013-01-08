//
//  PublishTableViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-31.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "PublishTableViewController.h"
#import "Tag.h"
#import "FoodDetailView.h"
#import "NetworkInterface.h"
#import "RestaurantTableViewController.h"

@interface PublishTableViewController () <RestaurantTableViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *foodDetailView;
@property (strong, nonatomic) NSMutableArray *tagArray;
@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (nonatomic) NSInteger selectedRestaurantIndex;
@property (strong, nonatomic) UIImage *defaultImage;

@end

@implementation PublishTableViewController
@synthesize foodDetailView = _foodDetailView;
@synthesize tagArray = _tagArray;
@synthesize restaurantArray = _restaurantArray;
@synthesize selectedRestaurantIndex = _selectedRestaurantIndex;

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
    self.selectedRestaurantIndex = -1;
    self.title = @"发布";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
    self.defaultImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    self.tagArray = [[NSMutableArray alloc] init];

    //[self.tableView setTableHeaderView:self.headerView];
    [self setupFetchedResultController];
    for (int i = 0; i < [self.fetchedResultsController.fetchedObjects count]; i++) {
        [self.tagArray addObject:[NSNumber numberWithBool:NO]];
    }
    [self requestForRestaurantArray];
    
    //UIImage *img =[UIImage imageNamed:@"detailBackground.png"];
    //[self.tableView setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailBackground.png"]];
    view.frame  = CGRectMake(10, 10, 640, 1136);
    self.tableView.backgroundView = view;
    
    
    
    
    //修改NavigationBar按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(-6, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"cancelButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(returnController:) forControlEvents:UIControlEventTouchUpInside];
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [leftButtonView addSubview:leftButton];
    UIBarButtonItem *leftResult = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftResult;
    
    
    
    //修改NavigationBar按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(completeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;
    
}

- (IBAction)returnController:(id)sender
{
//    UIViewController *publishTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainController"];
//    publishTableViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:publishTableViewController animated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)requestForRestaurantArray
{
    dispatch_queue_t fetchQ = dispatch_queue_create("RestaurantList fetcher", NULL);
    dispatch_async(fetchQ, ^{
        self.restaurantArray = [[NSMutableArray alloc] initWithArray:[NetworkInterface requestForRestaurantList]];
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchedResultController
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    requst.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tagID" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requst
                                                                managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"tagType"
                                                                                   cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"Selected:%d",self.selectedRestaurantIndex);
        if (self.selectedRestaurantIndex == -1) {
            return 1;
        }
        return 2;
    }
    return [[[self.fetchedResultsController sections] objectAtIndex:section - 1] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"餐馆";
    }
    return [[[self.fetchedResultsController sections] objectAtIndex:section - 1] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        return 0;
    }
    return 0;//[self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;//[self.fetchedResultsController sectionIndexTitles];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"PublishTableViewCellIdentifier";
         cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (self.selectedRestaurantIndex == -1) {
            cell.textLabel.text = @"餐馆";
            cell.detailTextLabel.text = @"无";
        } else {
            NSInteger index = self.selectedRestaurantIndex;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"餐馆";
                cell.detailTextLabel.text = [self.restaurantArray[index] objectForKey:@"餐馆名称"];
            } else {
                cell.textLabel.text = @"电话";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[self.restaurantArray[index]objectForKey:@"电话"] count]];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        static NSString *CellIdentifier = @"TagTableViewCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        if (indexPath.section == 1) {
            if ([self.tagArray[indexPath.row] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if ([self.tagArray[2 + indexPath.section] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1]];
        cell.textLabel.text = tag.tagName;

    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            self.tagArray[indexPath.row] = [NSNumber numberWithBool:YES];
            NSLog(@"%d", indexPath.row);
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            self.tagArray[indexPath.row] = [NSNumber numberWithBool:NO];
        }
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:1]; i ++) {
            if (i != indexPath.row) {
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                self.tagArray[i] = [NSNumber numberWithBool:NO];
            }
        }
    } else if (indexPath.section != 0) {
    
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            self.tagArray[2 + indexPath.section] = [NSNumber numberWithBool:YES];
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            self.tagArray[2 + indexPath.section] = [NSNumber numberWithBool:NO];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)getSelectedTagsFromTableView
{
    NSString *tagDes = @"";
    int i = 1;

    for (NSNumber *tagBool in self.tagArray) {
        if ([tagBool boolValue]) {
            tagDes = [tagDes stringByAppendingFormat:@"&%d", i];
        }
        i++;
    }
    if ([tagDes isEqual:@""]) {
        return @"";
    }
    return [tagDes substringFromIndex:1];
}

- (IBAction)completeButtonPushed:(UIBarButtonItem *)sender
{
    
    FoodDetailView *foodDetail = [self.foodDetailView.subviews objectAtIndex:0];

    NSString *foodName = foodDetail.foodNameTextField.text;
    if ([foodName isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请输入美食名称" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    NSString *foodPrice = foodDetail.foodPriceTextField.text;
    if ([foodPrice isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请输入美食价格" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (self.selectedRestaurantIndex == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请选择餐馆" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    int count = [[self.restaurantArray[self.selectedRestaurantIndex] objectForKey: @"电话" ] count];
    if (count <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请补全餐馆电话" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;

    }
    
    NSLog(@"selectedtag：%@", [self getSelectedTagsFromTableView]);
    NSString *tagsStr = [self getSelectedTagsFromTableView];
    if ([tagsStr isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请选择美食标签" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }    
    if (!foodDetail.imageChanged) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容遗漏警告" message:@"请传入美食图片" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    if (![self isPureFloat:foodPrice]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布内容错误警告" message:@"美食价格请输入整数或小数" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;

    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSString * nowStr = [dateformat stringFromDate:now];
    [dateformat setFormatterBehavior:NSDateFormatterFullStyle];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"%@",nowStr);
    
    NSData *dataImg = UIImageJPEGRepresentation(foodDetail.foodImageDetail.currentBackgroundImage, 0.001);
    UIImage *foodImage = [[UIImage alloc] initWithData:dataImg];
    
    NSString *path = [NetworkInterface generateRandomString:15];
    
    NSMutableArray *agrs = [[NSMutableArray alloc] init];
    NSLog(@"main thread begin...");
    [agrs addObject:foodName];
    [agrs addObject:foodPrice];
    [agrs addObject:nowStr];
    [agrs addObject:path];
    [agrs addObject:[self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"餐馆名称"]];
    [agrs addObject:tagsStr];
    [agrs addObject:foodImage];
    
    [self performSelectorInBackground:@selector(publishFoodToServerWithArray:) withObject:agrs];
    NSLog(@"main thread end.....");
    [self returnController:nil];
}

- (void)publishFoodToServerWithArray:(NSArray *)args
{
    [NetworkInterface PublishFood:args[0] foodprice:args[1] publishtime:args[2] foodimgname:args[3] restaurantname:args[4] tagsname:args[5]];
    [NetworkInterface UploadImage:args[6] picturename:args[3]];
    NSLog(@"发布成功！");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"发布成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

//- (void)publishFoodToServerWithFoodName:(NSString *)foodName WithFoodPrice:(NSString *)foodPrice WithPublishTime:(NSString *)publishTime WithFoodImagePath:(NSString *)path WithRestaurantName:(NSString *)restaurantName AndTagsName:(NSString *)tagsStr WithImage:(UIImage *)foodImage
//{
//    
//    [NetworkInterface PublishFood:foodName foodprice:foodPrice publishtime:publishTime foodimgname:path restaurantname:restaurantName tagsname:tagsStr];
//    [NetworkInterface UploadImage:foodImage picturename:path];
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RestaurantsSegueIndentifier"]) {
        
        RestaurantTableViewController *rtvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.tableView  indexPathForSelectedRow];
        
        if (indexPath.row == 0) {
            rtvc.deliveredTitle = @"餐馆";
            rtvc.listArray = self.restaurantArray;
            rtvc.selectedIndex = self.selectedRestaurantIndex;
            
        } else {
            rtvc.deliveredTitle = @"电话";
            rtvc.listArray = [self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"电话"];
            rtvc.restName = [self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"餐馆名称"];
        }
        rtvc.restaurantDelegate = self;
    }
}

#pragma mark - RestaurantTableViewControllerDelegate

- (void)sendTheSelectedRestaurantIndex:(NSInteger)index
{
    self.selectedRestaurantIndex = index;
    UITableViewCell *rCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (index != -1) {
        UITableViewCell *tCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        rCell.detailTextLabel.text = [self.restaurantArray[index] objectForKey:@"餐馆名称"];
        NSLog(@"餐馆名称:%@", [self.restaurantArray[index] objectForKey:@"餐馆名称"]);
        tCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[self.restaurantArray[index]objectForKey:@"电话"] count]];
        NSLog(@"电话数量:%@",  [NSString stringWithFormat:@"%d", [[self.restaurantArray[index]objectForKey:@"电话"] count]]);
        [self.tableView reloadData];
    } else {
        rCell.detailTextLabel.text = @"无";
    }
}

- (void)sendTheAddedTelephoneNumber:(NSString *)telephoneNumber
{
    NSMutableArray *telArr = [self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"电话"];
    [telArr addObject:telephoneNumber];
    [self.tableView reloadData];
}

- (void)sendTheAddedRestaurantName:(NSString *)restaurantName
{
    NSMutableDictionary *restaurantDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *telArray = [[NSMutableArray alloc] init];
    [restaurantDic setObject:restaurantName forKey:@"餐馆名称"];
    [restaurantDic setObject:telArray forKey:@"电话"];
    [self.restaurantArray addObject:restaurantDic];
    self.selectedRestaurantIndex = [self.restaurantArray count] - 1;
}

//判断是否为浮点形：

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}



@end
