//
//  HTServiceManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTServiceManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  创建DB以及所需的表，若本地已经创建，则忽略操作.
 */
- (void)createStorageServiceIfNeed;

@end
