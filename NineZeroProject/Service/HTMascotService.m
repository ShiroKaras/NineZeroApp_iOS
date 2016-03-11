//
//  HTMascotService.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotService.h"
#import "HTLogicHeader.h"

@implementation HTMascotService

- (void)getUserMascots:(HTGetMascotsCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMascotsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTMascot *> *mascots = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                [mascots addObject:[HTMascot objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]]];
            }
            callback(true, mascots);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getUserProps:(HTGetPropsCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMascotPropsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTMascotProp *> *props = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                [props addObject:[HTMascotProp objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]]];
            }
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

@end
