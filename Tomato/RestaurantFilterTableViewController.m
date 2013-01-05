//
//  RestaurantFilterTableViewController.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "RestaurantFilterTableViewController.h"
#import "Restaurant.h"

@interface RestaurantFilterTableViewController ()

@end

@implementation RestaurantFilterTableViewController
@synthesize restaurantArray = _restaurantArray;
@synthesize restDelegate = _restDelegate;

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
    [self setupFetchResultController];
    self.title = @"餐馆";
    
    if (self.restaurantArray == nil) {
        self.restaurantArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.fetchedResultsController.fetchedObjects count]; i++) {
            [self.restaurantArray addObject:[NSNumber numberWithBool:YES]];
        }
    }

    
    //修改NavigationBar按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(returnController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;

}

- (IBAction)returnController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@", [self getSelectedRestaurantsFromTableView]);
    [self.restDelegate sendTheFinalRestaurantArray:self.restaurantArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchResultController
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
    requst.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"restaurantID" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requst
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Restaurant *restaurant = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = restaurant.restaurantName;
    if ([self.restaurantArray[indexPath.row] boolValue] == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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

- (NSString *)getSelectedRestaurantsFromTableView
{
    NSString *tagDes = @"";
    int i = 1;
    for (NSNumber *tagBool in self.restaurantArray) {
        if ([tagBool boolValue]) {
            tagDes = [tagDes stringByAppendingFormat:@"&%d", i];
        }
        i++;
    }
    return tagDes;
}

- (IBAction)selectedAllButtonPushed:(id)sender {
    for (int i = 0; i < [self.restaurantArray count]; i ++) {
        self.restaurantArray[i] = [NSNumber numberWithBool:YES];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self.restaurantArray[indexPath.row] = [NSNumber numberWithBool:YES];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        self.restaurantArray[indexPath.row] = [NSNumber numberWithBool:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
