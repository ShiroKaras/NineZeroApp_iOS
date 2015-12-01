//
//  HTQiNiuService.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTQiNiuService.h"
#import <Qiniu/QiniuSDK.h>

@implementation HTQiNiuService {
    QNUploadManager *_uploadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _uploadManager = [[QNUploadManager alloc] init];
    }
    return self;
}

@end
