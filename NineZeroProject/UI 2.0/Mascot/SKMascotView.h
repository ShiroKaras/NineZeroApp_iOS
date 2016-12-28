//
//  SKMascotView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKMascotTypeDefault     = 0,
    SKMascotTypeSloth       = 1,
    SKMascotTypePride       = 2,
    SKMascotTypeWrath       = 3,
    SKMascotTypeGluttony    = 4,
    SKMascotTypeLust        = 5,
    SKMascotTypeEnvy        = 6
} SKMascotType;

@interface SKMascotView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;
- (void)show;
- (void)hide;
@end



@class SKMascotSkillView;
@protocol SKMascotSkillDelegate <NSObject>
- (void)didClickCloseButtonMascotSkillView:(SKMascotSkillView *)view;
@end

@interface SKMascotSkillView : UIView
@property (nonatomic, weak) id<SKMascotSkillDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType isHad:(BOOL)isHad;

@end




@interface SKMascotInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end
