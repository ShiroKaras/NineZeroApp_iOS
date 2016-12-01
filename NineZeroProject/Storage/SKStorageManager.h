//
//  SKStorageManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKStorageManager : NSObject

+ (instancetype)sharedInstance;

// user_id
- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;
- (void)clearUserID;

@end
