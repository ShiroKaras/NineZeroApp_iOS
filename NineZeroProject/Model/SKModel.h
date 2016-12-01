//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>



// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, strong) id data;                    // 返回数据
@property (nonatomic, strong) NSString *method;           // 方法名
@property (nonatomic, assign) NSInteger result;       // 结果code
@end
