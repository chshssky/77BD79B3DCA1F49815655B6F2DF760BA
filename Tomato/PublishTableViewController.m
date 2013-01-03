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

@interface PublishTableViewController () <RestaurantTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *foodDetailView;
@property (strong, nonatomic) NSMutableArray *tagArray;
@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (nonatomic) NSInteger selectedRestaurantIndex;

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
    [self setupFetchedResultController];
    self.selectedRestaurantIndex = -1;
    self.title = @"发布";
    //[self.tableView setTableHeaderView:self.headerView];
    self.tagArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.fetchedResultsController.fetchedObjects count]; i++) {
        [self.tagArray addObject:[NSNumber numberWithBool:NO]];
    }
    [self requestForRestaurantArray];
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

        if (indexPath.row == 0) {
            cell.textLabel.text = @"餐馆";
            if (self.selectedRestaurantIndex == -1) {
                cell.detailTextLabel.text = @"无";
            }
        } else {
            cell.textLabel.text = @"电话";
            if (self.selectedRestaurantIndex == -1) {
                cell.detailTextLabel.text = @"无";
            }
//            } else {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[self.restaurantArray[index]objectForKey:@"电话"] count]];
//            }

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
    } else if (indexPath.section == 0)
    {
        
//        RestaurantTableViewController *rtvc = [[RestaurantTableViewController alloc] init];
//        NSString *urlStr;
//        urlStr = @"http://192.168.2.162:8080/FoodShareSystem/servlet/GetRestaurantList";
//        NSURL *url = [[NSURL alloc] initWithString:urlStr];
//        self.restaurantArray = [[NSArray alloc] initWithContentsOfURL:url];
//
//        if (indexPath.row == 0) {
//            rtvc.deliveredTitle = @"餐馆";
//            rtvc.listArray = self.restaurantArray;
//            rtvc.selectedIndex = self.selectedRestaurantIndex;
//            
//        } else {
//            if (self.selectedRestaurantIndex == -1) {
//                [tableView deselectRowAtIndexPath:indexPath animated:NO];
//                return;
//            }
//            rtvc.deliveredTitle = @"电话";
//            rtvc.listArray = [self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"电话"];
//
//        }
//        rtvc.restaurantDelegate = self;
//        [self.navigationController pushViewController:rtvc animated:YES];
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
    return [tagDes substringFromIndex:1];
}

- (IBAction)completeButtonPushed:(UIBarButtonItem *)sender
{
    FoodDetailView *foodDetail = [self.foodDetailView.subviews objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSString * nowStr = [dateformat stringFromDate:now];
    [dateformat setFormatterBehavior:NSDateFormatterFullStyle];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"%@",nowStr);

    

    NSLog(@"%@ %@", foodDetail.foodNameTextField.text, foodDetail.foodPriceTextField.text);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@", [self getSelectedTagsFromTableView]);
    NSString *path = [NetworkInterface generateRandomString:15];
    [NetworkInterface PublishFood:foodDetail.foodNameTextField.text foodprice:foodDetail.foodPriceTextField.text publishtime:nowStr foodimgname:path restaurantname:[self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"餐馆名称"] tagsname:[self getSelectedTagsFromTableView]];
    NSLog(@"%@", foodDetail.foodImageDetail.currentBackgroundImage);
    [NetworkInterface UploadImage:foodDetail.foodImageDetail.currentBackgroundImage picturename:path];
    
}

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
    UITableViewCell *tCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (index != -1) {
        rCell.detailTextLabel.text = [self.restaurantArray[index] objectForKey:@"餐馆名称"];
        NSLog(@"%@", [self.restaurantArray[index] objectForKey:@"餐馆名称"]);
        tCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[self.restaurantArray[index]objectForKey:@"电话"] count]];
    } else {
        rCell.detailTextLabel.text = @"无";
        tCell.detailTextLabel.text = @"无";
    }
}

- (void)sendTheAddedTelephoneNumber:(NSString *)telephoneNumber
{
    NSMutableArray *telArr = [self.restaurantArray[self.selectedRestaurantIndex] objectForKey:@"电话"];
    [telArr addObject:telephoneNumber];
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



@end
