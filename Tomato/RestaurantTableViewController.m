//
//  RestaurantTableViewController.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-1.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "RestaurantTableViewController.h"
#import "NetworkInterface.h"

@interface RestaurantTableViewController () <UIAlertViewDelegate>

@end

@implementation RestaurantTableViewController
@synthesize deliveredTitle = _deliveredTitle;
@synthesize listArray = _listArray;
@synthesize restaurantDelegate = _restaurantDelegate;
@synthesize selectedIndex = _selectedIndex;
@synthesize restName = _restName;

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
    self.title = self.deliveredTitle;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%d", self.selectedIndex);
    if (self.title == @"餐馆") {
        [self.restaurantDelegate sendTheSelectedRestaurantIndex:self.selectedIndex];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RestaurantTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.deliveredTitle == @"餐馆") {
        NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:self.listArray[indexPath.row]];
        cell.textLabel.text = [dic objectForKey:@"餐馆名称"];
        if (self.selectedIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if (self.deliveredTitle == @"电话"){
        cell.textLabel.text = self.listArray[indexPath.row];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedIndex = indexPath.row;
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        self.selectedIndex = -1;
    }
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i ++) {
        if (i != indexPath.row) {
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)createButtonPushed:(id)sender {
    if (self.title == @"餐馆") {
        // 弹出 Alert 窗口
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"餐馆名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    } else {
        // 弹出 Alert 窗口
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"电话号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *inputString = [[alertView textFieldAtIndex:0] text];
        if (self.title == @"餐馆") {
            [self.restaurantDelegate sendTheAddedRestaurantName:inputString];
            self.selectedIndex = [self.listArray count] - 1;
        } else {
            [self.restaurantDelegate sendTheAddedTelephoneNumber:inputString];
            [NetworkInterface PublishRestaurant:self.restName telephone:inputString];
        }
        NSLog(@"%@", inputString);
        [self.tableView reloadData];

    }
    
}

@end
