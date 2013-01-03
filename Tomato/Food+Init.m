//
//  Food+Init.m
//  Tomato
//
//  Created by 崔 昊 on 13-1-2.
//  Copyright (c) 2013年 Cui Hao. All rights reserved.
//

#import "Food+Init.h"
#import "TomatoAppDelegate.h"
#import "Restaurant.h"
#import "Telephone.h"
#import "Food+Update.h"
#import "NetworkInterface.h"

@implementation Food (Init)

+ (void)initFood:(NSArray *)foods
inManagedObjectedContext:(NSManagedObjectContext *)context
{
    int i = 0;
    for (NSDictionary *dic in foods) {
        Food *food = nil;
        NSFetchRequest *foodRequest = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
        i ++;
        foodRequest.predicate = [NSPredicate predicateWithFormat:@"foodID = %d"/* AND foodPublishTime = %@"*/, i/*, [dic objectForKey:FOOD_UPLOAD_TIME]*/];
        
        NSError *foodError = nil;
        NSArray *foodMatches = [context executeFetchRequest:foodRequest error:&foodError];
        
        dispatch_queue_t network_queue;
        network_queue = dispatch_queue_create("network_queue", nil);
        dispatch_async(network_queue, ^{
            [NetworkInterface DownloadImage:[dic objectForKey:FOOD_IMAGE_PATH]];
        });
        
        if (!foodMatches || ([foodMatches count] > 1)) {
            NSLog(@"Food Wrong!");
        } else if ([foodMatches count] == 0) {
            food = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:context];
            food.foodID = [NSNumber numberWithInteger:i];
            
            food.foodName = [dic objectForKey:FOOD_NAME];
            
            food.foodPrice = [NSNumber numberWithFloat:[[dic objectForKey:FOOD_PRICE] floatValue]];
            
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
                NSArray *matches = [context executeFetchRequest:request error:&error];
                
                if (!matches || ([matches count] > 1)) {
                    NSLog(@"Food Add Tags Wrong!");
                } else if ([matches count] == 0) {
                    NSLog(@"Tags not init!");
                } else {
                    tag = [matches lastObject];
                    [food addTagsObject:tag];
                }
            }
            
            NSDictionary *rest = [dic objectForKey:RESTAURANT];
            
            Restaurant *res = nil;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Restaurant"];
            request.predicate = [NSPredicate predicateWithFormat:@"restaurantID = %@", [rest objectForKey:RESTAURANT_ID]];
            
            NSError *error = nil;
            NSArray *matches = [context executeFetchRequest:request error:&error];
            
            if (!matches || ([matches count] > 1)) {
                NSLog(@"Food Add Restaurant Wrong!");
            } else if ([matches count] == 0) {
                res = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:context];
                res.restaurantID = [NSNumber numberWithInteger:[[rest objectForKey:RESTAURANT_ID] integerValue]];
                NSLog(@"restaurantID:%@", [NSNumber numberWithInteger:[[rest objectForKey:RESTAURANT_ID] integerValue]]);
                res.restaurantName = [rest objectForKey:RESTAURANT_NAME];
                
                for (NSString *teleNumber in [rest objectForKey:RESTAURANT_TELEPHONE]) {
                    Telephone *tel = nil;
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Telephone"];
                    request.predicate = [NSPredicate predicateWithFormat:@"telephoneNumber = %@", teleNumber];
                    NSError *error = nil;
                    NSArray *matches = [context executeFetchRequest:request error:&error];
                    
                    if (!matches || ([matches count] > 1)) {
                        NSLog(@"Restaurant Add Telephones Wrong!");
                    } else if ([matches count] == 0) {
                        tel = [NSEntityDescription insertNewObjectForEntityForName:@"Telephone" inManagedObjectContext:context];
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
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
        } else {
            food = [foodMatches lastObject];
            [Food updateFood:food Score:[dic objectForKey:FOOD_SCORE] inManagedObjectContext:context];
        }
        
    }}

@end
