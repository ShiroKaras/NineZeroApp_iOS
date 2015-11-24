//
//  HTStorageManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/25.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTStorageManager : NSObject

+ (instancetype)sharedInstance;

- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;

- (void)updatePwdSalt:(NSString *)salt;
- (NSString *)getPwdSalt;

@end
