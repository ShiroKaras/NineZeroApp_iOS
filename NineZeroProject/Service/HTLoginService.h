//
//  HTLoginService.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLoginUser;

/**
 *  该类只允许HTServiceManager创建一次，多次创建直接crash
 *  通过HTServiceManager拿到该类的唯一实例
 */
@interface HTLoginService : NSObject

- (void)loginWithUser:(HTLoginUser *)user;

@end
