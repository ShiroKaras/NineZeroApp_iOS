//
//  HTDescriptionView.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/19.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WWKDescriptionTypeQuestion,  // defalut
    WWKDescriptionTypeProp,
    WWKDescriptionTypeUnknown,
} WWKDescriptionType;

@interface HTDescriptionView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;

- (void)showAnimated;

@end
