//
//  HTDescriptionView.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/19.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTDescriptionTypeQuestion,  // defalut
    HTDescriptionTypeProp,
    HTDescriptionTypeUnknown,
} HTDescriptionType;

@interface HTDescriptionView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString andType:(HTDescriptionType)type;
- (void)showAnimated;

@property (nonatomic, assign, readonly) HTDescriptionType type;

@end
