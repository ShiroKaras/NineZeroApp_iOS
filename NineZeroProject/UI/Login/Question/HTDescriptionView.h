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
    HTDescriptionTypeReward,
    HTDescriptionTypeBadge,
    HTDescriptionTypeUnknown,
} HTDescriptionType;

@class HTMascotProp;
@class HTReward;
@interface HTDescriptionView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString andType:(HTDescriptionType)type;

- (void)showAnimated;

@property (nonatomic, assign, readonly) HTDescriptionType type;
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, strong) HTReward *reward;
@end
