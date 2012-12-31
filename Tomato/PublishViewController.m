//
//  PublishViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-30.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "PublishViewController.h"
#import "NetworkInterface.h"

@interface PublishViewController ()

@end

@implementation PublishViewController
@synthesize foodImageButton = _foodImageButton;
@synthesize foodNameTextField = _foodNameTextField;
@synthesize foodPriceTextField = _foodPriceTextField;

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    [self.foodImageButton setBackgroundImage:image forState:UIControlStateNormal];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageButtonPushed:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"上传图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"拍照"
                                  otherButtonTitles:@"相册", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet destructiveButtonIndex] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])//判断camera是否可用。
        {
            NSLog(@"Camera 不可用");
            return;
        }
        [self getFoodPicture:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self getFoodPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex ==[actionSheet cancelButtonIndex]){
        return;
    }
    
}

- (void)getFoodPicture:(NSInteger)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"hello");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"HEllo 2");
    //info: A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        [self.foodImageButton setBackgroundImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请拍照而非录像" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
        [alert show];
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video , something wrong!");
    }
    [picker dismissModalViewControllerAnimated:YES];  //让其消失
}


- (IBAction)completeButtonPushed:(id)sender {
    NSLog(@"%@ %@", self.foodNameTextField.text, self.foodPriceTextField.text);
    
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"foodImage" ofType:@"png"];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
        NSString *path = [NetworkInterface generateRandomString:15];
        [NetworkInterface PublishFood:self.foodNameTextField.text foodprice:self.foodPriceTextField.text publishtime:@"2012-10-20 23:20:19" foodimgname:path restaurantname:@"KFC" tagsname:@"1&4&6"];
    NSLog(@"%@", self.foodImageButton.imageView.image);
        [NetworkInterface UploadImage:self.foodImageButton.imageView.image picturename:path];
}

@end
