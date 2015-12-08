//
//  HTNetworkDefine.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/24.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#ifndef HTNetworkDefine_h
#define HTNetworkDefine_h

// 公用
typedef void (^HTHTTPErrorCallback) (NSString *errorMessage);
typedef void (^HTHTTPSuccessCallback) (id responseObject);
typedef void (^HTNetworkCallback) (BOOL success, id responseObject);

// 七牛
typedef void (^HTGetTokenCallback) (NSString *token);

#endif /* HTNetworkDefine_h */
