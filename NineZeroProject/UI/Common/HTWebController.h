//
//  HTWebController.h
//  NineZeroProject
//
//  Created by ronhu on 16/4/5.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTWebController : UIViewController
- (instancetype)initWithURLString:(NSString *)urlString;
@property (nonatomic, copy) NSString *urlString;
@end
