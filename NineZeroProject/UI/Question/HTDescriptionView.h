//
//  HTDescriptionView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/19.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTDescriptionTypeQuestion,  // defalut
    HTDescriptionTypeProp,
    HTDescriptionTypeReward,
    HTDescriptionTypeBadge,
    HTDescriptionTypeUnknown,
} HTDescriptionType;

@class HTDescriptionView;
@class HTMascotProp;
@class HTTicket;
@class HTBadge;

@protocol HTDescriptionViewDelegate <NSObject>
- (void)descriptionView:(HTDescriptionView *)descView didChangeProp:(HTMascotProp *)prop;
@end

@interface HTDescriptionView : UIView

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString andType:(HTDescriptionType)type;
- (instancetype)initWithURLString:(NSString *)urlString andType:(HTDescriptionType)type andImageUrl:(NSString *)imageUrlString;

- (void)showAnimated;

@property (nonatomic, assign, readonly) HTDescriptionType type;
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, strong) HTTicket *reward;
@property (nonatomic, strong) HTBadge *badge;

@property (nonatomic, weak) id<HTDescriptionViewDelegate> delegate;

@end