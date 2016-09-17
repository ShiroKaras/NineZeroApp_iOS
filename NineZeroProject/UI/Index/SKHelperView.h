//
//  SKHelperView.h
//  NineZeroProject
//
//  Created by SinLemon on 16/9/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKHelperTypeHasMascot,
    SKHelperTypeNoMascot,
} SKHelperType;

@class SKHelperView;

@protocol SKHelperViewDelegate <NSObject>
@optional
- (void)didClickNextStepButtonInView:(SKHelperView *)view type:(SKHelperType)type index:(NSInteger)index;
@end

@interface SKHelperView : UIView
@property (nonatomic, strong) UIButton *nextstepButton;
@property (nonatomic, weak) id<SKHelperViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperType)type index:(NSInteger)index;
- (void)setImage:(UIImage *)image andText:(NSString *)text;
@end



//ScrollView
typedef enum : NSUInteger {
    SKHelperScrollViewTypeQuestion,
    SKHelperScrollViewTypeMascot,
    SKHelperScrollViewTypeAR
} SKHelperScrollViewType;

@interface SKHelperScrollView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dimmingView;
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperScrollViewType)type;
@end



//Guide
typedef enum : NSUInteger {
    SKHelperGuideViewType1,
    SKHelperGuideViewType2,
    SKHelperGuideViewType3
} SKHelperGuideViewType;

@interface SKHelperGuideView : UIView
- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperGuideViewType)type;
@end