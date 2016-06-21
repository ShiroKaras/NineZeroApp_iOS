//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"
#import "HTLogicHeader.h"

@implementation SKProfileService

#pragma mark 修改头像
- (void)createUpdateAvatarService:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key": SECRET_STRING,
                            @"action": @"new_update_user_avatar",
                            @"login_token": [[HTStorageManager sharedInstance] getLoginUser].token,
                            @"user_id": [[HTStorageManager sharedInstance] getUserID],
                            };
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseInfoCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];

}

@end
