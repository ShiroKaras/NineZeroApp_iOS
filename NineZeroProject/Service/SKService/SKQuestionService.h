//
//  SKQuestionService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"

@interface SKQuestionService : NSObject

- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback;

@end
