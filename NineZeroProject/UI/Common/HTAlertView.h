//
//  HTAlertView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/27.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTAlertViewTypeLocation,
    HTAlertViewTypePush,
    HTAlertViewTypePhotoLibrary,
    HTAlertViewTypeCamera,
    HTAlertViewTypeUnknown,
} HTAlertViewType;

@interface HTAlertView : UIView
- (instancetype)initWithType:(HTAlertViewType)type;
- (void)show;
@end
