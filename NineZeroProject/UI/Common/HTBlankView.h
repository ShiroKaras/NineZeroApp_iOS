//
//  HTBlankView.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTBlankViewType) {
    HTBlankViewTypeNetworkError,
    HTBlankViewTypeNoContent,
    HTBlankViewTypeUnknown,
};

@interface HTBlankView : UIView
// 默认为大，深色，宽度一定为屏幕宽度
- (instancetype)initWithType:(HTBlankViewType)type;
- (void)setImage:(UIImage *)image andOffset:(CGFloat)offset;
@end
