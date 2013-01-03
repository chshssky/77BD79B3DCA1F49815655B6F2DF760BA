//
//  NetworkInterface.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

//#define IP @"192.168.1.100"

#import "NetworkInterface.h"
#import "TomatoAppDelegate.h"
#import "Food+Init.h"
#import "Tag.h"
#import "Restaurant.h"
#import "Telephone.h"

#define IP @"192.168.1.103"
//#define USE_SERVER


@implementation NetworkInterface

+ (void)requestForFoodListFromID:(NSInteger) min toID:(NSInteger) max inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *ip = IP;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TomatoTest" ofType:@"plist"];
    NSString * urlstr = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/GetFoodList?fromid=%d&toid=%d", ip, min, max];
    NSURL *URL = [NSURL URLWithString:urlstr];
#ifdef USE_SERVER
    NSArray *foods = [[NSMutableArray alloc] initWithContentsOfURL:URL];
#else
    NSArray *foods = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
#endif
    [Food initFood:foods inManagedObjectedContext:context];

//        [document.managedObjectContext performBlock:^{
//            for (NSDictionary *flickrInfo in photos) {
//                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
//            }
//        }];
}


+ (void)giveGrade:(int)foodid OldGrade:(NSInteger)oldgrade NewGrade:(NSInteger)newgrade
{
    NSString *ip = IP;
    NSString * URL = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/GiveScore?foodid=%d&oldscore=%d&newscore=%d&ifgive=%@", ip, foodid,oldgrade,newgrade,@"true"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //[NSURLConnection connectionWithRequest:request delegate:self];
    //NSLog(@"%d",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
    
}

+(void) PublishFood:(NSString *)name foodprice:(NSString *)price publishtime:(NSString *)time foodimgname:(NSString *)imgname restaurantname:(NSString *)restaurantname tagsname:(NSString *)tagsname
{
    NSString *ip = IP;
    //URL = [URL stringByAppendingFormat:@"?foodname=%@&foodprice=%@&publishtime=%@&foodimgname=%@&restaurantname=%@",name,price,time,imgname,restaurantname];
    //NSLog(@"%@",URL);
    NSString * URL = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/PublishFood", ip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"foodname=%@\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"foodprice=%@\n",price] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"publishtime=%@\n",time] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"foodimgname=%@\n",imgname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"restaurantname=%@\n",restaurantname] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"tagsname=%@\n",tagsname] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"tag=bbbb\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"tag=cccc\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //[NSURLConnection connectionWithRequest:request delegate:self];
    NSLog(@"%d",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
    
}

+(void) UploadImage:(UIImage *)img picturename:(NSString *)picture_name
{
    NSString *ip = IP;
    NSString * URL = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/UploadPicture", ip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; picture_name=%@",picture_name];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(img)]];
    
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


+(NSString *)generateRandomString :(int)length
{
    NSString * allchar = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString * str = @"";
    //int pos = arc4random()%(allchar.length);
    for (int i=0; i<length; i++) {
        str = [str stringByAppendingFormat:@"%c",[allchar characterAtIndex:arc4random()%(allchar.length)]];
    }
    return str;
}

+ (void)PublishRestaurant:(NSString *)name telephone:(NSString *)tel
{
    NSString *ip = IP;
    NSString * URL = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/PublishRestaurant", ip];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"restaurant=%@\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"telephone=%@\n",tel] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //[NSURLConnection connectionWithRequest:request delegate:self];
    NSLog(@"%d", [returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
}

+ (NSArray *)requestForRestaurantList
{
    NSString *ip = IP;
    NSString *urlStr;
    urlStr = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/GetRestaurantList", ip];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    return [[NSArray alloc] initWithContentsOfURL:url];
}

+ (void)DownloadImage:(NSString *)imagename
{
    NSString *ip = IP;
    NSString * URL = [NSString stringWithFormat:@"http://%@:8080/FoodShareSystem/servlet/DownloadPicture?filename=%@", ip, imagename];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%d",[returnData length]);
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:imagename ofType:@"jpg"];
    //NSLog(@"%@",imagePath);
    NSString * dirname = @"/Documents/";
    NSString * imagefullname = [imagename stringByAppendingString:@".jpg"];
    imagefullname = [dirname stringByAppendingString:imagefullname];
    NSString * imagePath = [NSHomeDirectory() stringByAppendingPathComponent:imagefullname];
    NSLog(@"%@",imagePath);
    [returnData writeToFile: imagePath atomically:YES];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


@end
