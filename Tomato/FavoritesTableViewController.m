//
//  FavoritesTableViewController.m
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "FavoriteTableViewCell.h"
#import "Collection+Edit.h"
#import "Food.h"


@interface FavoritesTableViewController ()
@property (nonatomic, strong) NSMutableArray *selectedRow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation FavoritesTableViewController
@synthesize editButton = _editButton;
@synthesize selectedRow = _selectedRow;

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

- (NSMutableArray *)selectedRow
{
    if (_selectedRow == nil) {
        _selectedRow = [[NSMutableArray alloc] init];
    }
    return _selectedRow;
}

- (IBAction)editButtonClicked:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self.editButton setTitle:@"删除"];
    [self.editButton setAction:@selector(editButtonClickedWithSure:)];
}

- (IBAction)editButtonClickedWithSure:(id)sender
{
    int count = [self.selectedRow count];
    if (count > 0 ) {
        [Collection DeleteCollections:self.selectedRow withFetchedResultController:self.fetchedResultsController inManagedObjectContext:self.managedObjectContext];
        [self.selectedRow removeAllObjects];
        [self.editButton setAction:@selector(editButtonClicked:)];
        [self.editButton setTitle:@"编辑"];
        [self.tableView setEditing:NO animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未选中任何数据!" delegate:self cancelButtonTitle:@"重新选择" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"编辑"];
        [self.editButton setAction:@selector(editButtonClicked:)];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.editButton.title isEqualToString:@"删除"]) {
        [self.selectedRow removeObject:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.editButton.title isEqualToString:@"删除"]) {
        [self.selectedRow addObject:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



- (void)setupFetchResultController
{
    NSFetchRequest *collectionRequest = [NSFetchRequest fetchRequestWithEntityName:@"Collection"];
    collectionRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"collectionID" ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:collectionRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteTableViewCellIdentifier";
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Collection *collet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.foodNameLabel.text = collet.food.foodName;
    cell.foodScoreLabel.text = [NSString stringWithFormat:@"%@", collet.food.foodScore];
    cell.foodImage.backgroundColor = [UIColor grayColor];
    
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


@end
