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
#import "Food+Update.h"
#import "TomatoDetailViewController.h"
#import "Tag.h"
#import "NetworkInterface.h"

@interface FavoritesTableViewController () <TomatoDetailViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *selectedRow;
@property (weak, nonatomic) IBOutlet UINavigationItem *favoriteNavigationBar;
@property (nonatomic) BOOL whetherCanRemove;
@property (nonatomic) BOOL whetherTakeout;

@end

@implementation FavoritesTableViewController
@synthesize selectedRow = _selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.tableView setEditing:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupFetchResultController];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"editButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;
    
    self.whetherCanRemove = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFetchResultController];
    [self.navigationController setTitle:@"稍后再吃"];
    [self.favoriteNavigationBar setTitle:@"稍后再吃"];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
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
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
//    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    [self.tableView setEditing:YES animated:YES];
    //[self.editButton setTitle:@"删除"];
    //[self.editButton setTitle:@"取消"];
    //[self.editButton setAction:@selector(editButtonClickedWithSure:)];
    
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"finishButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(editButtonClickedWithCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;
    
    self.whetherCanRemove = YES;
}



//- (IBAction)cancelButtonClicked:(id)sender
//{
//    [self.tableView setEditing:NO animated:YES];
//    [self.editButton setTitle:@"编辑"];
//    [self.editButton setAction:@selector(editButtonClicked:)];
//    [self.favoriteNavigationBar setLeftBarButtonItem:nil];
//}

- (IBAction)editButtonClickedWithCancel:(id)sender
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 64, 48)];
    //UIImage *icon = [UIImage imageNamed:@" "];
    //[button setImage:icon forState:UIControlStateNormal];
    //[button setImage:icon forState:UIControlStateHighlighted];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"editButtonClicked.png"] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 48)];
    [rightButtonView addSubview:rightButton];
    
    UIBarButtonItem *rightResult = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightResult;
    
    [self.tableView setEditing:NO animated:YES];
    self.whetherCanRemove = NO;

}

//- (IBAction)editButtonClickedWithSure:(id)sender
//{
//    int count = [self.selectedRow count];
//    if (count > 0 ) {
//        [Collection DeleteCollections:self.selectedRow withFetchedResultController:self.fetchedResultsController inManagedObjectContext:self.managedObjectContext];
//        [self.selectedRow removeAllObjects];
//        [self.editButton setAction:@selector(editButtonClicked:)];
//        [self.editButton setTitle:@"编辑"];
//        [self.tableView setEditing:NO animated:YES];
//    }else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未选中任何数据!" delegate:self cancelButtonTitle:@"重新选择" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *selectedRow = [[NSMutableArray alloc] init];
    [selectedRow addObject:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Collection DeleteCollections:selectedRow withFetchedResultController:self.fetchedResultsController inManagedObjectContext:self.managedObjectContext];
    }
}


//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whetherCanRemove == YES) {
        [self.selectedRow removeObject:indexPath];
    }
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whetherCanRemove == YES) {
        [self.selectedRow addObject:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}

- (NSString *)imageFilePath:(NSString *)imageName
{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:@"jpg"]];
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
    
    Food *food = collet.food;
    cell.foodNameLabel.text = collet.food.foodName;
    //cell.foodImageView =
//    cell.foodScoreLabel.text = [NSString stringWithFormat:@"%@", collet.food.foodScore];
//    cell.foodImage.backgroundColor = [UIColor grayColor];
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
        NSData *dataImg = UIImageJPEGRepresentation(fullImage, 0.3);
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
    cell.foodImageView.image = [UIImage imageNamed:@"foodImageNoneBackground.png"];
    
    [cell.foodNameLabel setHighlightedTextColor:[UIColor blackColor]];
    cell.foodNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [cell.foodScoreLabelA setHighlightedTextColor:[UIColor orangeColor]];
    cell.foodScoreLabelA.font = [UIFont italicSystemFontOfSize:26.0f];
    [cell.foodScoreLabelB setHighlightedTextColor:[UIColor orangeColor]];
    cell.foodScoreLabelB.font = [UIFont italicSystemFontOfSize:16.0f];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"FavoriteDetailSegueIdentifier"]) {
        TomatoDetailViewController *dvc = [segue destinationViewController];
        Collection *collection = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        dvc.foodDetail = collection.food;
        dvc.detailDelegate = self;
        
        self.whetherTakeout = NO;
        NSMutableArray *signMutableArray = [[NSMutableArray alloc]initWithArray:[collection.food.tags allObjects]];
        for (int i=0; i<[signMutableArray count]; i++) {
            Tag *foodSign = signMutableArray[i];
            if ([foodSign.tagID intValue] == 5) {
                self.whetherTakeout = YES;
            }
        }
        dvc.whetherTakeout = self.whetherTakeout;
    }
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
