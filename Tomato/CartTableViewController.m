//
//  CartTableViewController.m
//  Tomato
//
//  Created by lisiqi on 12-11-16.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "CartTableViewController.h"
#import "Cart.h"
#import "CartFooterView.h"
#import <MessageUI/MFMessageComposeViewController.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CartTableViewController ()  <MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, retain) NSNumber *tempSection;


@end

@implementation CartTableViewController
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.tableView reloadSectionIndexTitles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    Cart *cart = [Cart getCart];
    int numberOfSectionsInTableView = [cart getRestaurantNameCount];
    return numberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Cart *cart = [Cart getCart];
    int restaurantFoodCount = [cart getRestaurantFoodCount:section];
    if (restaurantFoodCount == 0) {
        return restaurantFoodCount;
    }else{
        return restaurantFoodCount+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CartTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cart *cart = [Cart getCart];
    if ([cart getRestaurantFoodNameAndPriceAtSection:indexPath.section AtRow:indexPath.row NameOrPrice:@"Name"] != nil){
        cell.textLabel.text = [cart getRestaurantFoodNameAndPriceAtSection:indexPath.section AtRow:indexPath.row NameOrPrice:@"Name"];
        cell.detailTextLabel.text = [@"¥" stringByAppendingString:[cart getRestaurantFoodNameAndPriceAtSection:indexPath.section AtRow:indexPath.row NameOrPrice:@"Price"]];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }else{
        cell.textLabel.text = @"总价";
        cell.detailTextLabel.text = [@"¥" stringByAppendingString:[cart getTheRestaurantSumPriceAtSection:indexPath.section]];
            cell.textLabel.textColor = UIColorFromRGB(0xBD1421);
            cell.detailTextLabel.textColor = UIColorFromRGB(0xBD1421);
    }
    
    return cell;
}

//返回Section标题内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Cart *cart = [Cart getCart];
    NSString *restaurantName = [cart getRestaurantName:section];
    return restaurantName;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CartFooterView * footerView = [[CartFooterView alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(241, 5, 70, 40);
    [button setTitle:@"订购" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    [footerView addSubview:button];
    footerView.confirmButton = button;
    
    return footerView;
}

- (IBAction)confirmButtonClicked:(UIButton *)sender
{
    Cart *cart = [Cart getCart];
    NSString *restaurantName = [cart getRestaurantName:sender.tag];
    NSString *call = [@"呼叫 " stringByAppendingString:restaurantName];
    NSString *message = [@"短信 " stringByAppendingString:restaurantName];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"订购外卖"
                                  delegate:self
                                  cancelButtonTitle:@"取消订购"
                                  destructiveButtonTitle:call
                                  otherButtonTitles:message, nil]; 
    actionSheet.tag = sender.tag;
    self.tempSection = [NSNumber numberWithInt:sender.tag];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //callTelephone
        Cart *cart = [Cart getCart];
        NSString *telePhoneNumber = [@"tel://" stringByAppendingString:[cart getRestaurantTelephoneNumber:actionSheet.tag]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telePhoneNumber]];
        for (int i=0; i<[cart getRestaurantFoodCount:actionSheet.tag]; i++) {
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:actionSheet.tag]].accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }else if (buttonIndex == 1) {
        //ssendMessage
        Cart *cart = [Cart getCart];
        NSString *telePhoneNumber = [cart getRestaurantTelephoneNumber:actionSheet.tag];
        NSString *SMSText = @"";
        
        for (int k=0; k< [cart getRestaurantFoodCount:actionSheet.tag]; k++) {
            SMSText = [SMSText stringByAppendingString:@"(收到请回复)定购外卖:  "];
            SMSText = [SMSText stringByAppendingString:[cart getRestaurantFoodNameAndPriceAtSection:actionSheet.tag AtRow:k NameOrPrice:@"Name"]];
            SMSText = [SMSText stringByAppendingString:@"1份 + "];
        }
        SMSText = [SMSText stringByAppendingString:@"我的地址:"];
        
        if( [MFMessageComposeViewController canSendText] )
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            
            controller.recipients = [NSArray arrayWithObject:telePhoneNumber];
            controller.body = SMSText;
            controller.messageComposeDelegate = self;
            
            [self presentModalViewController:controller animated:YES];
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"SomethingElse"];//修改短信界面标题
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"该设备不支持短信功能"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
//        for (int i=0; i<[cart getRestaurantFoodCount:actionSheet.tag]; i++) {
//            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:actionSheet.tag]].accessoryType = UITableViewCellAccessoryCheckmark;
//        }
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://800888"]];
    }else if(buttonIndex ==[actionSheet cancelButtonIndex]){
        return;
    }
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:NO];
    Cart *cart = [Cart getCart];
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled");
        NSLog(@"%@",self.tempSection);
        for (int i=0; i<[cart getRestaurantFoodCount:[self.tempSection intValue]]; i++) {
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:[self.tempSection intValue]]].accessoryType = UITableViewCellAccessoryNone;
        }
    }else if (result == MessageComposeResultSent){
        NSLog(@"Message sent");
        for (int i=0; i<[cart getRestaurantFoodCount:[self.tempSection intValue]]; i++) {
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:[self.tempSection intValue]]].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else{
       NSLog(@"Message failed");
        for (int i=0; i<[cart getRestaurantFoodCount:[self.tempSection intValue]]; i++) {
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:[self.tempSection intValue]]].accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cart *cart = [Cart getCart];
    if ([cart getRestaurantFoodNameAndPriceAtSection:indexPath.section AtRow:indexPath.row NameOrPrice:@"Name"] != nil &&
        [cart getRestaurantFoodNameAndPriceAtSection:indexPath.section AtRow:indexPath.row NameOrPrice:@"Price"] != nil) {
        return YES;
    }else{
        return NO;
    }   
}


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



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cart *cart = [Cart getCart];
    int restaurantFoodCount = [cart getRestaurantFoodCount:indexPath.section];
//    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]].textLabel.textColor = [UIColor blackColor];
//    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]].detailTextLabel.textColor = [UIColor blackColor];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
        
        [cart deleteRestaurantFoodAtSection:indexPath.section AtRow:indexPath.row];
        
        if (restaurantFoodCount == 1) {
            [self.delegate changeAddToCartButtonState];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:YES];
        }else{
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation: UITableViewRowAnimationNone];
            [self.tableView reloadData];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

@end
