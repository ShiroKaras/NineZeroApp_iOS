//
//  HTProfilePopView.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/24.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfilePopView.h"
#import "HTUIHeader.h"
#import "HTProfileRewardController.h"
#import "HTProfileArticlesController.h"
#import "HTProfileRootController.h"
#import "HTPreviewCardController.h"
#import "HTStorageManager.h"

typedef enum : NSUInteger {
    HTProfileTypePerson,
    HTProfileTypeRecord,
    HTProfileTypeReward,
    HTProfileTypeArticle,
} HTProfileType;

@interface HTPopView : UIView
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *decorateImageView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;
@property (nonatomic, weak) HTProfilePopView *profilePopView;
@end
@implementation HTPopView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, [self intrinsicContentSize].width, [self intrinsicContentSize].height)]) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_list_bg"]];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        HTUserInfo *userInfo = [[HTStorageManager sharedInstance] userInfo];
        
        _head = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _head.userInteractionEnabled = YES;
        [_bgView addSubview:_head];
        
        _name = [[UILabel alloc] init];
        _name.text = userInfo.user_name;
        _name.textColor = COMMON_GREEN_COLOR;
        _name.font = [UIFont systemFontOfSize:14];
        [_name sizeToFit];
        [_bgView addSubview:_name];
        
        _decorateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_list_deco"]];
        [_bgView addSubview:_decorateImageView];
        
        _itemButtons = [NSMutableArray arrayWithCapacity:4];
        NSArray *titles = @[@"个人主页", @"闯关纪录", @"奖品礼券", @"往期文章",];
        for (int i = 0; i != 4; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.titleLabel.textColor = [UIColor colorWithHex:0xb0b0b0];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = i;
            [button setTitleColor:[UIColor colorWithHex:0xb0b0b0] forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_itemButtons addObject:button];
            [_bgView addSubview:button];
        }
    }
    return self;
}

- (void)onClickButton:(UIButton *)button {
    UIViewController *controller = UIViewParentController(self);
    switch ((HTProfileType)button.tag) {
        case HTProfileTypePerson: {
            HTProfileRootController *rootController = [[HTProfileRootController alloc] init];
            HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
            [controller presentViewController:navController animated:YES completion:nil];
            break;
        }
        case HTProfileTypeRecord: {
            HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeRecord];
            [controller presentViewController:cardController animated:YES completion:nil];
            break;
        }
        case HTProfileTypeReward: {
            HTProfileRewardController *rewardController = [[HTProfileRewardController alloc] init];
            HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rewardController];
            [controller presentViewController:navController animated:YES completion:nil];
            break;
        }
        case HTProfileTypeArticle: {
            HTProfileArticlesController *articleController = [[HTProfileArticlesController alloc] initWithStyle:UITableViewStylePlain];
            HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:articleController];
            [controller presentViewController:navController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.profilePopView.delegate profilePopViewWillDismiss:self.profilePopView];
        [self.superview removeFromSuperview];
    });
}

- (CGSize)intrinsicContentSize {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_list_bg"]];
    return CGSizeMake(imageView.width, imageView.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgView.frame = CGRectMake(0, 0, self.width, self.height);
    _head.top = 12;
    _head.size = CGSizeMake(56, 56);
    _head.centerX = self.width / 2;
    _name.centerX = _head.centerX;
    _name.top = _head.bottom + 12;
    _decorateImageView.centerX = _head.centerX;
    _decorateImageView.top = _name.bottom + 13;
    for (int i = 0; i != self.itemButtons.count; i++) {
        UIButton *button = self.itemButtons[i];
        button.width = self.width;
        button.height = 16;
        button.centerX = _head.centerX;
        button.top = _decorateImageView.bottom + 13 + 36 * i;
        [button setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    }
}

@end

@interface HTProfilePopView ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) HTPopView *alertView;
@end

@implementation HTProfilePopView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UITapGestureRecognizer *tapOnMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMaskView)];
        [_maskView addGestureRecognizer:tapOnMaskView];
        
        _alertView = [[HTPopView alloc] initWithFrame:CGRectZero];
        _alertView.profilePopView = self;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self addSubview:_maskView];
        [self addSubview:_alertView];
        _alertView.alpha = 0.0;
        _maskView.alpha = 0.0;
        [UIView animateWithDuration:0.1 animations:^{
            _maskView.alpha = 1.0;
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _alertView.alpha = 1.0;
        }];
    }
}

- (void)onClickMaskView {
    [self.delegate profilePopViewWillDismiss:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _maskView.frame = self.frame;
    _alertView.bottom = SCREEN_HEIGHT - 55;
    _alertView.right = SCREEN_WIDTH - 17;
}

@end
