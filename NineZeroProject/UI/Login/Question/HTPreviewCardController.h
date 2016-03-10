//
//  HTPreviewCardController.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTPreviewCardTypeDefault,
    HTPreviewCardTypeRecord,
    HTPreviewCardTypeUnknown,
} HTPreviewCardType;

@interface HTPreviewCardController : UIViewController
- (instancetype)initWithType:(HTPreviewCardType)type;
- (void)backToToday;
@end
