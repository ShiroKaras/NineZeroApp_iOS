//
//  HTProgressHUD.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/24.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProgressHUD.h"
#import "HTUIHeader.h"

@interface HTProgressHUD ()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HTProgressHUD

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HTProgressHUD *progress;
    dispatch_once(&onceToken, ^{
        progress = [[HTProgressHUD alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    return progress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dimmingView = [[UIView alloc] initWithFrame:frame];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:_dimmingView];
        
        NSInteger count = 40;
        NSMutableArray *images = [NSMutableArray array];
        _imageView = [[UIImageView alloc] init];
        for (int i = 0; i != count; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_00%02d", i]];
            [images addObject:image];
        }
        _imageView.animationImages = images;
        _imageView.animationDuration = 2.0;
        _imageView.animationRepeatCount = 0;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)showAnimated {
    [self updateViewHierachy];
    [_imageView startAnimating];
    [self setNeedsLayout];
}

- (void)dismiss {
    [self removeFromSuperview];
    [_imageView stopAnimating];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _imageView.frame = CGRectMake(0, 0, 156, 156);
    _imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
}

- (void)updateViewHierachy {
    if (!self.superview) {
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                _dimmingView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    _dimmingView.alpha = 1;
                }];
                break;
            }
        }
    } else {
        [self.superview bringSubviewToFront:self];
    }
}

+ (void)show {
    [[HTProgressHUD sharedInstance] showAnimated];
}

+ (void)dismiss {
    [[HTProgressHUD sharedInstance] dismiss];
}

@end
