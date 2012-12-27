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

- (void)requestForFoodList;
{
    dispatch_queue_t fetchQ = dispatch_queue_create("FoodList fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TomatoTest" ofType:@"plist"];
        NSArray *foods = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        int i = 0;
        for (NSDictionary *dic in foods) {
            Food *food = nil;
            NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
            foodRequest.predicate = [NSPredicate predicateWithFormat:@"foodName = %@"/* AND foodPublishTime = %@"*/, [dic objectForKey:FOOD_NAME]/*, [dic objectForKey:FOOD_UPLOAD_TIME]*/];
            
            NSError *foodError = nil;
            NSArray *foodMatches = [self.managedObjectContext executeFetchRequest:foodRequest error:&foodError];
            
            if (!foodMatches || ([foodMatches count] > 1)) {
                NSLog(@"Food Wrong!");
            } else if ([foodMatches count] == 0) {
                food = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:self.managedObjectContext];
                food.foodID = [NSNumber numberWithUnsignedInt:i++];
                
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
                food = [foodMatches lastObject];
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



@end
