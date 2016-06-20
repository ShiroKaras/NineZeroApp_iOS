//
//  SKNetworkDefine.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#ifndef SKNetworkDefine_h
#define SKNetworkDefine_h
#import "SKModel.h"

// 公用
typedef void (^SKHTTPErrorCallback) (NSString *errorMessage);
typedef void (^SKHTTPSuccessCallback) (id responseObject);
typedef void (^SKNetworkCallback) (BOOL success, id responseObject);

typedef void (^SKResponseCallback) (BOOL success, SKResponsePackage *response);

// 七牛
typedef void (^SKGetTokenCallback) (NSString *token);


#endif /* SKNetworkDefine_h */
