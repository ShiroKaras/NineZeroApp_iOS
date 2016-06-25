//
//  SKMascotService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotService.h"
#import "SKServiceManager.h"

@implementation SKMascotService

- (void)getBaseMascotsInfo:(SKGetMascotsCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager resource_getMascot_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager resourceCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            //TODO
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getUserMascots:(SKGetMascotsCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"access_key": SECRET_STRING,
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getMascot_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userProfileCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSMutableArray<SKMascot *> *mascots = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                SKMascot *mascot = [SKMascot mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]];
                //获取未读文章数
//                mascot.unread_articles = mascot.articles - [[HTStorageManager sharedInstance] getMascotInfoWithIndex:mascot.mascotID].articles;
                [mascots addObject:mascot];
            }
            callback(true, mascots);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}


@end
