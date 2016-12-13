//
//  SKCommonService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKGetTokenCallback) (NSString *token);

@interface SKCommonService : NSObject

// 首页信息
- (void)getHomepageInfoCallBack:(SKResponseCallback)callback;

// Qiniu Token
- (void)getQiniuPublicTokenWithCompletion:(SKGetTokenCallback)callback;

// 获取文件完整地址

@end
