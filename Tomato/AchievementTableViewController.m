//
//  AchievementTableViewController.m
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "AchievementTableViewController.h"
#import "AchievementsTableViewCell.h"
#import "Achievement.h"
#import "Record.h"

@interface AchievementTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *achievementNavigationBar;

@end

@implementation AchievementTableViewController

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
    [self.navigationController setTitle:@"我的荣誉"];
    [self.achievementNavigationBar  setTitle:@"我的荣誉"];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailBackground.png"]];
    view.frame  = CGRectMake(10, 10, 640, 1136);
    self.tableView.backgroundView = view;


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

- (void)setupFetchResultController
{
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName:@"Achievement"];
    requst.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"achievementID" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requst
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupFetchResultController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AchievementsTableViewCellIdentifier";
    AchievementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AchievementsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Achievement *achieve = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.achievementNameLabel.text = achieve.achievementName;
    cell.achievementDescriptionLabel.text = achieve.achievementDecription;
    cell.achievementImageView.image = [UIImage imageNamed:[self getImage:achieve.achievementName]];
    if ([achieve.achievementThreshold integerValue] <= [achieve.achievementRecord.recordCount integerValue]) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"achievementBackground.png"]];
    } else {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"achievementBackgroundN.png"]];
    }
    cell.achievementRecordLabel.text = [NSString stringWithFormat:@"%@", achieve.achievementRecord.recordCount];
    return cell;
}

- (NSString *) getImage:(NSString *)imageName
{
    NSString *imageURL;
    if ([imageName isEqualToString:@"重口味"]) {
        imageURL = @"hot.png";
    }else if ([imageName isEqualToString:@"小清新"]) {
        imageURL = @"fresh.png";
    }else if ([imageName isEqualToString:@"胖子"]) {
        imageURL = @"fat.png";
    }else if ([imageName isEqualToString:@"来者不拒"]) {
        imageURL = @"noRefused.png";
    }else if ([imageName isEqualToString:@"速食主义"]) {
        imageURL = @"junk.png";
    }else if ([imageName isEqualToString:@"宅神"]) {
        imageURL = @"house.png";
    }else if ([imageName isEqualToString:@"蕃茄至尊"]) {
        imageURL = @"tomato.png";
    }else if ([imageName isEqualToString:@"吃货"]) {
        imageURL = @"eat.png";
    }
    return imageURL;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"achievementBackground.png"]]; //cell的背景图
//    //cell.textLabel.backgroundColor = [UIColor clearColor];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0;
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
