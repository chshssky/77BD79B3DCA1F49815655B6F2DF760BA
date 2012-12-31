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

@interface PublishTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *foodDetailView;
@property (strong, nonatomic) NSMutableArray *tagArray;

@end

@implementation PublishTableViewController
@synthesize foodDetailView = _foodDetailView;
@synthesize tagArray = _tagArray;

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
    self.title = @"发布";
    //[self.tableView setTableHeaderView:self.headerView];
    self.tagArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.fetchedResultsController.fetchedObjects count]; i++) {
        [self.tagArray addObject:[NSNumber numberWithBool:NO]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchedResultController
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    requst.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"tagType" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requst
                                                                managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"tagType"
                                                                                   cacheName:nil];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PublishTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.tagName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            self.tagArray[indexPath.row] = [NSNumber numberWithBool:YES];
            NSLog(@"%d", indexPath.row);
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            self.tagArray[indexPath.row] = [NSNumber numberWithBool:NO];

        }
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; i ++) {
            if (i != indexPath.row) {
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                self.tagArray[i] = [NSNumber numberWithBool:NO];
            }
        }
    } else {
    
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType != UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            self.tagArray[3 + indexPath.section] = [NSNumber numberWithBool:YES];
            NSLog(@"%d", 3 + indexPath.section);
        } else {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            self.tagArray[3 + indexPath.section] = [NSNumber numberWithBool:NO];
            NSLog(@"%d", 3 + indexPath.section);
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
    return [tagDes substringFromIndex:1];
}

- (IBAction)completeButtonPushed:(UIBarButtonItem *)sender
{
    FoodDetailView *foodDetail = [self.foodDetailView.subviews objectAtIndex:0];

    NSLog(@"%@ %@", foodDetail.foodNameTextField.text, foodDetail.foodPriceTextField.text);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@", [self getSelectedTagsFromTableView]);
//    NSString *path = [NetworkInterface generateRandomString:15];
//    [NetworkInterface PublishFood:foodDetail.foodNameTextField.text foodprice:foodDetail.foodPriceTextField.text publishtime:@"2012-10-20 23:20:19" foodimgname:path restaurantname:@"KFC" tagsname:@"1&4&6"];
//    NSLog(@"%@", foodDetail.foodImageDetail.currentBackgroundImage);
//    [NetworkInterface UploadImage:foodDetail.foodImageDetail.currentBackgroundImage picturename:path];
    
}

@end
