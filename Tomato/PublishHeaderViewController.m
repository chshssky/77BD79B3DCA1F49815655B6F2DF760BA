//
//  PublishHeaderViewController.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-31.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "PublishHeaderViewController.h"

@interface PublishHeaderViewController ()

@end

@implementation PublishHeaderViewController
@synthesize foodDetailView = _foodDetailView;

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
    self.foodDetailView.imageChanged = NO;
    UIImage *image = [[UIImage alloc] init];
    [self.foodDetailView.foodImageDetail setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)foodImagePushed:(UIButton *)sender {
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
        [self.foodDetailView.foodImageDetail setBackgroundImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        self.foodDetailView.imageChanged = YES;
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请拍照而非录像" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
        [alert show];
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"found a video , something wrong!");
    }
    [picker dismissModalViewControllerAnimated:YES];  //让其消失
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender
{
    [self.foodNameTextField resignFirstResponder];
    [self.foodPriceTextField resignFirstResponder];
}

@end
