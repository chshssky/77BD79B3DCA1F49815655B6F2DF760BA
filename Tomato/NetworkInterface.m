//
//  NetworkInterface.m
//  Tomato
//
//  Created by 崔 昊 on 12-12-25.
//  Copyright (c) 2012年 Cui Hao. All rights reserved.
//

#import "NetworkInterface.h"
#import "TomatoAppDelegate.h"
#import "Food.h"
#import "Tag.h"
#import "Restaurant.h"
#import "Telephone.h"

@implementation NetworkInterface
@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    TomatoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _managedObjectContext = delegate.managedObjectContext;
    return _managedObjectContext;
    
}

- (void)requestForFoodListFromID:(NSInteger) min toID:(NSInteger) max
{
    dispatch_queue_t fetchQ = dispatch_queue_create("FoodList fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TomatoTest" ofType:@"plist"];
        NSString * urlstr = [NSString stringWithFormat:@"http://192.168.2.162:8080/FoodShareSystem/servlet/GetFoodList?fromid=%d&toid=%d", min, max];
        NSURL *URL = [NSURL URLWithString:urlstr];
        NSArray *foods = [[NSMutableArray alloc] initWithContentsOfURL:URL];
        //NSArray *foods = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        int i = 1;
        for (NSDictionary *dic in foods) {
            Food *food = nil;
            NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
            foodRequest.predicate = [NSPredicate predicateWithFormat:@"foodID = %d"/* AND foodPublishTime = %@"*/, i/*, [dic objectForKey:FOOD_UPLOAD_TIME]*/];
            
            NSError *foodError = nil;
            NSArray *foodMatches = [self.managedObjectContext executeFetchRequest:foodRequest error:&foodError];
            
            if (!foodMatches || ([foodMatches count] > 1)) {
                NSLog(@"Food Wrong!");
            } else if ([foodMatches count] == 0) {
                food = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
                food.foodID = [NSNumber numberWithInteger:i++];
                
                food.foodName = [dic objectForKey:FOOD_NAME];
                
                food.foodPrice = [NSNumber numberWithInteger:[[dic objectForKey:FOOD_PRICE] integerValue]];
                
                food.foodGrade = [NSNumber numberWithUnsignedInt:0];
                
                food.foodImagePath = [dic objectForKey:FOOD_IMAGE_PATH];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
                food.foodPublishTime = [dateFormatter dateFromString:[dic objectForKey:FOOD_UPLOAD_TIME]];
                
                food.foodScore = [NSNumber numberWithFloat:[[dic objectForKey:FOOD_SCORE] floatValue]];
                
                for (NSString *tagIndex in [dic objectForKey:FOOD_TAGS]) {
                    Tag *tag = nil;
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
                    request.predicate = [NSPredicate predicateWithFormat:@"tagID = %@", tagIndex];
                    
                    NSError *error = nil;
                    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
                    
                    if (!matches || ([matches count] > 1)) {
                        NSLog(@"Food Add Tags Wrong!");
                    } else if ([matches count] == 0) {
                        NSLog(@"Tags not init!");
                    } else {
                        tag = [matches lastObject];
                    }
                    [food addTagsObject:tag];
                }
                
                NSDictionary *rest = [dic objectForKey:RESTAURANT];
                
                //Restaurant ID
                Restaurant *res = nil;
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
                request.predicate = [NSPredicate predicateWithFormat:@"restaurantName = %@", [rest objectForKey:RESTAURANT_NAME]];
                
                NSError *error = nil;
                NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
                
                if (!matches || ([matches count] > 1)) {
                    NSLog(@"Food Add Restaurant Wrong!");
                } else if ([matches count] == 0) {
                    res = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:self.managedObjectContext];
                    res.restaurantName = [rest objectForKey:RESTAURANT_NAME];
                    
                    for (NSString *teleNumber in [rest objectForKey:RESTAURANT_TELEPHONE]) {
                        Telephone *tel = nil;
                        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Telephone"];
                        request.predicate = [NSPredicate predicateWithFormat:@"telephoneNumber = %@", teleNumber];
                        NSError *error = nil;
                        NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
                        
                        if (!matches || ([matches count] > 1)) {
                            NSLog(@"Restaurant Add Telephones Wrong!");
                        } else if ([matches count] == 0) {
                            tel = [NSEntityDescription insertNewObjectForEntityForName:@"Telephone" inManagedObjectContext:self.managedObjectContext];
                            tel.telephoneNumber = teleNumber;
                        } else {
                            tel = [matches lastObject];
                        }
                        [res addTelephonesObject:tel];
                    }
                } else {
                    res = [matches lastObject];
                }
                food.restaurant = res;
                error = nil;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            } else {
                food.foodPrice = [NSNumber numberWithInteger:[[dic objectForKey:FOOD_PRICE] integerValue]];
            }

        }

//        [document.managedObjectContext performBlock:^{
//            for (NSDictionary *flickrInfo in photos) {
//                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
//            }
//        }];
    });
    //dispatch_release(fetchQ);
}


+ (void)giveGrade:(int)foodid OldGrade:(NSInteger)oldgrade NewGrade:(NSInteger)newgrade
{
    NSString * URL = [NSString stringWithFormat:@"http://192.168.2.162:8080/FoodShareSystem/servlet/GiveScore?foodid=%d&oldscore=%d&newscore=%d&ifgive=%@",foodid,oldgrade,newgrade,@"true"];
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
    //URL = [URL stringByAppendingFormat:@"?foodname=%@&foodprice=%@&publishtime=%@&foodimgname=%@&restaurantname=%@",name,price,time,imgname,restaurantname];
    //NSLog(@"%@",URL);
    NSString * URL = @"http://192.168.2.162:8080/FoodShareSystem/servlet/PublishFood";
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
    NSString * URL = @"http://192.168.2.162:8080/FoodShareSystem/servlet/UploadPicture";
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
    NSString * URL = @"http://192.168.2.162:8080/FoodShareSystem/servlet/PublishRestaurant";
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
    NSLog(@"%d",[returnData length]);
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
}


@end
