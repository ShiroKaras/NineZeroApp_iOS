//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

// 不要覆盖description方法
@interface NSObject (PropertyPrint)
- (NSString *)debugDescription;
@end

// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, strong) id data;                    // 返回数据
@property (nonatomic, strong) NSString *method;           // 方法名
@property (nonatomic, assign) NSInteger result;       // 结果code
@end
