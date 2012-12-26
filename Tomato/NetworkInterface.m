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

- (void)requestForFoodListfrom:(NSInteger) minIndex upTo:(NSInteger) maxIndex
{
    dispatch_queue_t fetchQ = dispatch_queue_create("FoodList fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TomatoTest" ofType:@"plist"];
        NSArray *foods = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        int i = 0;
        for (NSDictionary *dic in foods) {
            Food *food = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
            food.foodID = [NSNumber numberWithUnsignedInt:i++];
            food.foodName = [dic objectForKey:@"名称"];
            food.foodPrice = [dic objectForKey:@"价格"];
            food.foodGrade = [NSNumber numberWithUnsignedInt:0];
            food.foodImagePath = [dic objectForKey:@"图片"];
            food.foodPublishTime = [dic objectForKey:@"上传时间"];
            food.foodScore = [dic objectForKey:@"评分"];
            for (NSString *tagIndex in [dic objectForKey:@"美食标签"]) {
                Tag *tag = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
                tag.tagID = [NSNumber numberWithInteger:[tagIndex integerValue]];
                [food addTagsObject:tag];
            }
//            NSDictionary *rest = [dic objectForKey:@"餐馆"];
//            Restaurant *res = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:self.managedObjectContext];
//            res.restaurantName = [rest objectForKey:@"名称"];
//            res.restaurantID = [rest objectForKey:];
//
//            food.restaurant = res;
            
        }
        
//        [document.managedObjectContext performBlock:^{
//            for (NSDictionary *flickrInfo in photos) {
//                [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
//            }
//        }];
    });
    //dispatch_release(fetchQ);
}



@end
