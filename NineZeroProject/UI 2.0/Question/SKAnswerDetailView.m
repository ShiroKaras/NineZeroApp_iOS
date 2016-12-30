//
//  SKAnswerDetailView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/7/4.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKAnswerDetailView.h"
#import "HTUIHeader.h"
#import "Reachability.h"
#import "JPUSHService.h"
#import "HTAlertView.h"
#import "HTBlankView.h"
#import "UIImage+ImageEffects.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SKAnswerDetailView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSString *quesitonID;
@property (nonatomic, strong) SKAnswerDetail *answerDetail;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIButton *cancelButton;           //关闭按钮
@property (nonatomic, strong) UIImageView *headerImageView;     //头图
@property (nonatomic, strong) UIImageView *contentImageView;    //内容封面（不一定显示）
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *contentView;          //文字内容

@property (nonatomic, strong) UIView *articleBackView;
@property (nonatomic, strong) UIButton *arrowButton;

@property (nonatomic, strong) UIView *HUDView;
@property (nonatomic, strong) UIImageView *HUDImageView;

@property (nonatomic, strong) NSArray *articlesArray;
@end

@implementation SKAnswerDetailView{
    NSInteger articleCount;
    float lastOffsetY;
}

- (instancetype)initWithFrame:(CGRect)frame questionID:(NSString *)questionID{
    if (self = [super init]) {
        _quesitonID = questionID;
        self.frame = frame;
        [self createUI];
        [self loadDataWithQuestionID:_quesitonID];
    }
    return self;
}

- (void)loadDataWithQuestionID:(NSString *)questionID {
    _contentView.alpha = 0;
    _backImageView.alpha = 0;
    
    [[[SKServiceManager sharedInstance] questionService] getQuestionAnswerDetailWithQuestionID:_quesitonID callback:^(BOOL success, SKAnswerDetail *answerDetail) {
        self.answerDetail = answerDetail;
        _contentView.text = answerDetail.article_desc;
        [_contentView sizeToFit];
        _contentView.centerX = self.centerX;
        
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.article_pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_backImageView setImage:[image applyLightEffect]];
            [self hideHUD];
            [UIView animateWithDuration:0.5 animations:^{
                _contentView.alpha = 1.0;
                _backImageView.alpha = 1.0;
                _headerImageView.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.article_pic_1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        if (answerDetail.article_Illustration_type == 0) {
            _contentImageView.hidden = YES;
            _contentView.top = _headerImageView.bottom +16;
        } else if (answerDetail.article_Illustration_type == 1) {
            _playButton.hidden = NO;
            [_contentImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.article_Illustration_cover_url]];
        } else if (answerDetail.article_Illustration_type == 2) {
            [_contentImageView sd_setImageWithURL:[NSURL URLWithString:answerDetail.article_Illustration_url]];
        }
        
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in _backScrollView.subviews)
            scrollViewHeight += view.frame.size.height;
        [_backScrollView setContentSize:(CGSizeMake(self.frame.size.width, scrollViewHeight+52.5+56+21))];
    }];
}

- (void)createUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    _backImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backImageView];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _backScrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.alwaysBounceVertical = YES;
    _backScrollView.delegate = self;
    [self addSubview:_backScrollView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 11+40+5, self.frame.size.width-14, (self.frame.size.width-14)/307*72)];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backScrollView addSubview:_headerImageView];
    
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _headerImageView.bottom+12, self.width-20, (self.width-20)/280*157.5)];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backScrollView addSubview:_contentImageView];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.hidden = YES;
    [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    [_backScrollView addSubview:_playButton];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_contentImageView);
    }];
    
    _contentView = [[UILabel alloc] initWithFrame:CGRectMake(10, _contentImageView.bottom+16, self.width-20, 500)];
    _contentView.textColor = [UIColor colorWithHex:0xd9d9d9];
    _contentView.font = PINGFANG_FONT_OF_SIZE(14);
    _contentView.numberOfLines = 0;
    _contentView.textAlignment = NSTextAlignmentCenter;
    [_backScrollView addSubview:_contentView];
    
    _HUDView = [[UIView alloc] initWithFrame:self.frame];
    _HUDView.backgroundColor = [UIColor blackColor];
    NSInteger count = 40;
    NSMutableArray *images = [NSMutableArray array];
    CGFloat length = 156;
    _HUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - length / 2, SCREEN_HEIGHT / 2 - length / 2, length, length)];
    for (int i = 0; i != count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_00%02d", i]];
        [images addObject:image];
    }
    _HUDImageView.animationImages = images;
    _HUDImageView.animationDuration = 2.0;
    _HUDImageView.animationRepeatCount = 0;
    [_HUDView addSubview:_HUDImageView];
    
    [self showHUD];
}

- (void)showHUD {
    [AppDelegateInstance.window addSubview:_HUDView];
    _HUDView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _HUDView.alpha = 1;
        [_HUDImageView startAnimating];
    }];
}

- (void)hideHUD {
    [_HUDView removeFromSuperview];
}

- (void)playVideo {
    NSURL *videoURL = [NSURL URLWithString:self.answerDetail.article_Illustration_url];
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [[self viewController] presentViewController:playerViewController animated:YES completion:nil];
    [playerViewController.player play];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging && !scrollView.decelerating) {
        if (scrollView.contentOffset.y - lastOffsetY > 25) {
            DLog(@"ScrollUp now: %lf %lf", lastOffsetY, scrollView.contentOffset.y);
            lastOffsetY = MIN(scrollView.contentOffset.y, scrollView.contentSize.height-SCREEN_HEIGHT);
        }
        else if (lastOffsetY - scrollView.contentOffset.y > 25){
            DLog(@"ScrollDown now: %lf %lf", lastOffsetY, scrollView.contentOffset.y);
            lastOffsetY = MIN(scrollView.contentOffset.y, scrollView.contentSize.height-SCREEN_HEIGHT);
        }
    }
}

#pragma mark - Action

//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
