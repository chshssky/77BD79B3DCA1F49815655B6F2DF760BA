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
#import "Food+Update.h"
#import "FilterTableViewController.h"
#import "Tag.h"
#import "Tag+Init.h"
#import "PublishTableViewController.h"
#import "Food+Examine.h"
#import "Food+Insert.h"

@interface TomatoTableViewController () <FilterTableViewControllerDelegate, TomatoDetailViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *foodTags;
@property (strong, nonatomic) NSMutableArray *foodRestaurants;
@property (nonatomic) BOOL whetherTakeout;
@property (weak, nonatomic) IBOutlet UINavigationItem *foodNavigationBar;
@property (nonatomic) NSInteger loadCount;

@end

@implementation TomatoTableViewController
@synthesize foodTags = _foodTags;
@synthesize foodRestaurants = _foodRestaurants;
@synthesize loadCount = _loadCount;

-(void)setupFetch
{
    [self setupFetchResultController];
    [self.tableView reloadData];
}

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
    
    self.loadCount = 5;
    
    if ([NetworkInterface isConnectionAvailable]) {
        NSLog(@"Connection YES");
    } else {
        NSLog(@"Connection NO");
    }
    if (_refreshTableView == nil) {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        refreshView.delegate = self;
        //将下拉刷新控件作为子控件添加到UITableView中
        [self.tableView addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    if (_loadMoreTableFooter == nil) {
        LoadMoreTableFooterView *view = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _loadMoreTableFooter = view;
    }
    
    
    //[NetworkInterface requestForFoodListFromID:0 toID:10 inManagedObjectContext:self.managedObjectContext];
    [NetworkInterface requestForFoodListFromID:-1 ToID:-1 Count:self.loadCount inManagedObjectContext:self.managedObjectContext];
    [self setupFetchResultController];
    
    self.foodTags = nil;
    self.foodRestaurants = nil;
    [self.navigationController setTitle:@"番茄美食"];
    [self.foodNavigationBar setTitle:@"番茄美食"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //修改NavigationBar按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(-6, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted]; 
    [leftButton setBackgroundImage:[UIImage imageNamed:@"selectButton.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"selectButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [leftButton addTarget:self action:@selector(goToFilterTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [leftButtonView addSubview:leftButton];
    
    UIBarButtonItem *leftResult = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftResult;
    
    //修改NavigationBar按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"publishButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"publishButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(goToPublishTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;
    
    //获取是否还有数据，设置_hasMore
    _hasMore = YES;

}

- (IBAction)goToPublishTableViewController:(id)sender
{
    //PublishTableViewController *publishTableViewController = [[PublishTableViewController alloc] init];
    UIViewController *publishTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"newPublish"];
    publishTableViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:publishTableViewController animated:YES completion:nil];
    [self presentModalViewController:publishTableViewController animated:YES]; 
    //[self.navigationController pushViewController:publishTableViewController animated:YES];
    
}

- (IBAction)goToFilterTableViewController:(id)sender
{
    //FilterTableViewController *filterTableViewController = [[FilterTableViewController alloc] init];
    
    //用StoryBoard指定ID初始化
    UIViewController* filterTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"newFilter"];
    
    FilterTableViewController *ftvc = filterTableViewController.childViewControllers[0];
    ftvc.tagArray = self.foodTags;
    ftvc.restaurantArray = self.foodRestaurants;
    ftvc.filterDelegate = self;
    //设定跳转方法的跳转
    filterTableViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //[self presentViewController:filterTableViewController animated:YES completion:nil];
    
    [self presentModalViewController:filterTableViewController animated:YES]; 
    
    
    
    //向左推送的方式跳转controller
    //[self.navigationController pushViewController:filterTableViewController animated:YES];
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
        NSString *predicateStr = @"";
        for (int i = 1; i <= [self.foodTags count] - 2; i ++) {
            if ([self.foodTags[i - 1] boolValue]) {
                predicateStr = [predicateStr stringByAppendingFormat:@" OR (ANY tags == %d)", i];
            }
        }
        for (int i = 5; i <= [self.foodTags count]; i ++) {
            if ([self.foodTags[i - 1] boolValue]) {
                predicateStr = [predicateStr stringByAppendingFormat:@") AND (ANY tags == %d)", i];
            } else {
                predicateStr = [predicateStr stringByAppendingString:@")"];// OR (ANY tags == %d)", i];
            }
        }
        predicateStr = [predicateStr substringFromIndex:4];
        predicateStr = [@"((" stringByAppendingString:predicateStr];
        NSString *restaurantStr = @"";
        if (self.foodRestaurants != nil) {
            for (int i = 1; i <= [self.foodRestaurants count]; i ++) {
                if ([self.foodRestaurants[i - 1] boolValue]) {
                    restaurantStr = [restaurantStr stringByAppendingFormat:@"OR (restaurant == %d)", i];
                }
            }
            
            restaurantStr = [restaurantStr substringFromIndex:3];
            restaurantStr = [restaurantStr stringByAppendingString:@")"];
            restaurantStr = [@") AND (" stringByAppendingString:restaurantStr];
            predicateStr = [predicateStr stringByAppendingString:restaurantStr];
            predicateStr = [@"(" stringByAppendingString:predicateStr];
        }
        request.predicate = [NSPredicate predicateWithFormat:predicateStr];
        [self.tableView reloadData];
    }
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"foodID" ascending:NO]];
    
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

- (NSString *)imageFilePath:(NSString *)imageName
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:@"jpg"]];
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
    
    cell.foodScoreLabelA.text = [NSString stringWithFormat:@"%d",[food.foodScore intValue]];
    int pointNumber = ([food.foodScore floatValue] - [food.foodScore intValue])*10;
    cell.foodScoreLabelB.text = [@"." stringByAppendingString:[NSString stringWithFormat:@"%d",pointNumber]];
    
    cell.foodImageView.image = [UIImage imageNamed:@"foodImageNoneBackground.png"];
    
    cell.takeoutImage.image = nil;
    cell.tasteImage.image = nil;
    cell.junkfoodImage.image = nil;
    
    NSMutableArray *signMutableArray = [[NSMutableArray alloc]initWithArray:[food.tags allObjects]];
    for (int i=0; i<[signMutableArray count]; i++) {
        Tag *foodSign = signMutableArray[i];
        if ([foodSign.tagID intValue] == 5) {
            cell.takeoutImage.image = [UIImage imageNamed:@"takeoutSign.png"];
            [signMutableArray removeObjectAtIndex:i];
        }
    }
    if ([signMutableArray count] == 2) {
        Tag *foodSign1 = signMutableArray[0];
        Tag *foodSign2 = signMutableArray[1];
        cell.tasteImage.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign1.tagID intValue]]];
        cell.junkfoodImage.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign2.tagID intValue]]];
    }else if ([signMutableArray count] == 1) {
        Tag *foodSign1 = signMutableArray[0];
        cell.tasteImage.image = [UIImage imageNamed:[self getFoodSignImage:[foodSign1.tagID intValue]]];
    }

    dispatch_queue_t image_queue;
    image_queue = dispatch_queue_create("image_queue", nil);
    dispatch_async(image_queue, ^{
        
        //cell.foodImageView.image = [UIImage imageWithContentsOfFile:[self imageFilePath:food.foodImagePath]];
        
        UIImage *fullImage = [UIImage imageWithContentsOfFile:[self imageFilePath:food.foodImagePath]];
        NSData *dataImg = UIImageJPEGRepresentation(fullImage, 0.03);
        UIImage *smallImage = [[UIImage alloc] initWithData:dataImg];

        dispatch_async(dispatch_get_main_queue(), ^{
            cell.foodImageView.image = smallImage;
            
            [cell reloadInputViews];
        });
    });
    
    UIImage *selectedImage = [UIImage imageNamed:@"cellClickedBackground.png"];
    UIImageView *selectedView = [[UIImageView alloc] initWithImage:selectedImage];
    [cell setSelectedBackgroundView:selectedView];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"cellUnclickedBackground.png"];
    UIImageView *unselectedView = [[UIImageView alloc] initWithImage:unselectedImage];
    [cell setBackgroundView:unselectedView];
    
    [cell.foodNameLabel setHighlightedTextColor:[UIColor blackColor]];
    cell.foodNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [cell.foodScoreLabelA setHighlightedTextColor:[UIColor orangeColor]];
    cell.foodScoreLabelA.font = [UIFont italicSystemFontOfSize:26.0f];
    [cell.foodScoreLabelB setHighlightedTextColor:[UIColor orangeColor]];
    cell.foodScoreLabelB.font = [UIFont italicSystemFontOfSize:16.0f];
    return cell;
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


//开始重新加载时调用的方法
- (void)reloadTableViewDataSource{
    _reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //刷新表格内容
    [self setupFetchResultController];
    _hasMore = YES;
    [_loadMoreTableFooter setFooterLabelIfHasData];
     //[self.tableView reloadData];
}

//这个方法运行于子线程中，完成获取刷新数据的操作
-(void)doInBackground
{
    //更新数据库
    //[NetworkInterface requestForFoodListFromID:0 toID:20 inManagedObjectContext:self.managedObjectContext];
    Food *food = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [NetworkInterface requestForFoodListFromID:[food.foodID integerValue] ToID:-1 Count:self.loadCount inManagedObjectContext:self.managedObjectContext];
    
    //[NSThread sleepForTimeInterval:5];
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
    if(scrollView.contentOffset.y < 0){
        [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
    }
    else if(_hasMore){
        [_loadMoreTableFooter loadMoreScrollViewDidScroll:scrollView];
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < 0){
        [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    }else if(_hasMore){
        [_loadMoreTableFooter loadMoreScrollViewDidEndDragging:scrollView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//////////上提加载部分/////////////


- (void)loadMoreTableViewDataSource {
    _loadingMore = YES;
    [NSThread detachNewThreadSelector:@selector(loadMore) toTarget:self withObject:nil];
}


- (void)doneLoadMoreTableViewData {
    _loadingMore = NO;
    [_loadMoreTableFooter loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //后台加载数据完成
    NSLog(@"加载数据完成");
    
    //获取是否还有数据，设置_hasMore
    
    Food *food = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0]];
    _hasMore = [Food IsTheLastFood:food];
    if (_hasMore == NO) {
        [_loadMoreTableFooter setFooterLabelIfNoMoreData];
    }
}

- (void)loadMore
{
    //此处后台加载新的数据
    Food *food = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0]];
    [NetworkInterface requestForFoodListFromID:-1 ToID:[food.foodID integerValue] Count:self.loadCount inManagedObjectContext:self.managedObjectContext];
    
    [NSThread sleepForTimeInterval:3];

    [self performSelectorOnMainThread:@selector(doneLoadMoreTableViewData) withObject:nil waitUntilDone:YES];
}

-(void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view
{
    _loadingMore = YES;
    [self loadMoreTableViewDataSource];
}

-(BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return _loadingMore;
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"cellClickedBackgroud.png"];
//    cell.imageView.alpha = 0.5;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"cellClickedBackgroud.png"];
//    cell.imageView.alpha = 0.5;
//    return indexPath;
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.imageView.alpha = 0.1;
//}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"TomatoDetailSegueIdentifier"]) {
        TomatoDetailViewController *dvc = [segue destinationViewController];
        
        dvc.foodDetail = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        dvc.detailDelegate = self;
        Food *food = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        self.whetherTakeout = NO;
        NSMutableArray *signMutableArray = [[NSMutableArray alloc]initWithArray:[food.tags allObjects]];
        for (int i=0; i<[signMutableArray count]; i++) {
            Tag *foodSign = signMutableArray[i];
            if ([foodSign.tagID intValue] == 5) {
                self.whetherTakeout = YES;
            }
        }
        dvc.whetherTakeout = self.whetherTakeout;
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

#pragma mark - TomatoDetailViewControllerDelegate

- (void)requestForFoodScore:(Food *)food
{
    dispatch_queue_t reload_score_queue;
    reload_score_queue = dispatch_queue_create("reload_score_queue", nil);
    dispatch_async(reload_score_queue, ^{
        
        double foodScore = [NetworkInterface getFoodScore:[food.foodID integerValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Food updateFood:food Score:[NSNumber numberWithDouble:foodScore] inManagedObjectContext:self.managedObjectContext] ;
            [self.tableView reloadData];
            
        });
    });

}

@end
