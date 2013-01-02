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
