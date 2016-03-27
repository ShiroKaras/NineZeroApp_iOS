//
//  HTAlertView.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/27.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTAlertViewTypeLocation,
    HTAlertViewTypePush,
    HTAlertViewTypeUnknown,
} HTAlertViewType;

@interface HTAlertView : UIView
- (instancetype)initWithType:(HTAlertViewType)type;
- (void)show;
@end
