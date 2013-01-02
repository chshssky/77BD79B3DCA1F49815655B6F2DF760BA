//
//  TomatoTableViewController.m
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "TomatoTableViewController.h"
#import "TomatoAppDelegate.h"
#import "FoodTomatoTableViewCell.h"
#import "TomatoDetailViewController.h"
#import "NetworkInterface.h"
#import "Food.h"
#import "FilterTableViewController.h"

@interface TomatoTableViewController () <FilterTableViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *foodTags;
@property (strong, nonatomic) NSMutableArray *foodRestaurants;

@end

@implementation TomatoTableViewController
@synthesize foodTags = _foodTags;
@synthesize foodRestaurants = _foodRestaurants;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_refreshTableView == nil) {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.tableView addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    NetworkInterface *net = [[NetworkInterface alloc] init];
    [net requestForFoodListFromID:0 toID:10];
    [self setupFetchResultController];
    
    self.foodTags = nil;
    self.foodRestaurants = nil;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    _refreshTableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupFetchResultController];
}

- (void)setupFetchResultController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    if (self.foodTags != nil) {
//        NSString *predicateStr = @"";
//        for (int i = 1; i <= [self.foodTags count]; i ++) {
//            if ([self.foodTags[i - 1] boolValue]) {
//                predicateStr = [predicateStr stringByAppendingFormat:@"OR tags contains %d ", i];
//                NSLog(@"i: %d", i);
//            }
//        }
//        predicateStr = [predicateStr substringFromIndex:2];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == 4"];
        
        [self.tableView reloadData];
    }
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:YES]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FoodTableViewCellIdentifier";
    FoodTomatoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FoodTomatoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //configure the cell
    Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.foodNameLabel.text = food.foodName;
    cell.foodGradeLabel.text = [NSString stringWithFormat:@"%@",food.foodScore];
    
    
    
//    NSInteger index = indexPath.row;
//    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:self.foodList[index]];
//    
//    cell.foodNameLabel.text = [dic objectForKey:FOOD_NAME];
//    cell.foodGradeLabel.text = [dic objectForKey:FOOD_SCORE];
//    NSArray *arr = [[NSArray alloc] initWithArray:[dic objectForKey:FOOD_TAGS]];
//    NSString *tag = @"";
//    
//    for (NSString *index in arr) {
//        tag = [tag stringByAppendingFormat:@"  %@", self.foodTags[[index integerValue] - 1]];
//    }
//    cell.foodTagLabel.text = tag;
    
    return cell;
}


//开始重新加载时调用的方法
- (void)reloadTableViewDataSource{
    _reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData{
    NSLog(@"doneLoadingTableViewData");
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //刷新表格内容
    [self setupFetchResultController];
    
    [self.tableView reloadData];
}

//这个方法运行于子线程中，完成获取刷新数据的操作
-(void)doInBackground
{
    NSLog(@"doInBackground");
    
    //更新数据库
    NetworkInterface *net = [[NetworkInterface alloc] init];
    [net requestForFoodListFromID:0 toID:10];
    
    
    [NSThread sleepForTimeInterval:3];
    
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}

//下拉被触发调用的委托方法
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

//返回当前是刷新还是无刷新状态
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

//返回刷新时间的回调方法
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"TomatoDetailSegueIdentifier"]) {
        TomatoDetailViewController *dvc = [segue destinationViewController];
        
        dvc.foodDetail = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    } else if ([segue.identifier isEqualToString:@"FilterSegueIdentifier"]) {
        FilterTableViewController *ftvc = [segue destinationViewController];
        ftvc.tagArray = self.foodTags;
        ftvc.restaurantArray = self.foodRestaurants;
        ftvc.filterDelegate = self;
    }
}

#pragma mark - FilterTableViewControllerDelegate

- (void)sendTheFinalTags:(NSMutableArray *)tagArr andTheFinalRestaurants:(NSMutableArray *)restaurantArr
{
    self.foodRestaurants = restaurantArr;
    self.foodTags = tagArr;
}

@end
