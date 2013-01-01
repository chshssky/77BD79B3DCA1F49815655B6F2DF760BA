//
//  FilterTableViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "FilterTableViewController.h"
#import "Tag.h"

@interface FilterTableViewController ()

@end

@implementation FilterTableViewController

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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
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
        static NSString *CellIdentifier = @"RestaurantFilterCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"餐馆";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        static NSString *CellIdentifier = @"TagFilterCellIdentifier";
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
    } else if (indexPath.section == 0) {
        
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


@end
