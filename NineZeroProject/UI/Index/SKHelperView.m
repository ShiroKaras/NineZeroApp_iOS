//
//  SKHelperView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKHelperView.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"

@interface SKHelperView (){

}
@property (nonatomic, strong) UIImageView   *cardImageView;
@property (nonatomic, strong) UILabel       *textLabel;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, assign) SKHelperType  type;

@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end

@implementation SKHelperView

- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperType)type index:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        _index = index;
        _type = type;
        
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-276)/2, (SCREEN_HEIGHT-356)/2, 276, 356)];
        cardView.layer.cornerRadius = 5;
        cardView.layer.masksToBounds = YES;
        cardView.backgroundColor = [UIColor colorWithHex:0x1D1D1D];
        [self addSubview:cardView];
        
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 276, 293)];
        _cardImageView.layer.masksToBounds = YES;
        [cardView addSubview:_cardImageView];
        
        _playBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 276, 276)];
        [cardView addSubview:_playBackView];
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 2;
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _textLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
        [cardView addSubview:_textLabel];
        
        if (type == SKHelperTypeHasMascot) {
            UIImageView *mascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_introduce_talk"]];
            [cardView addSubview:mascotImageView];
            
            [mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@105);
                make.height.equalTo(@87);
                make.left.equalTo(cardView.mas_left);
                make.bottom.equalTo(cardView.mas_bottom);
            }];
            
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mascotImageView.mas_right).offset(8);
                make.top.equalTo(_cardImageView.mas_bottom).offset(3);
                make.right.equalTo(_cardImageView.mas_right).offset(-12);
            }];
        } else if(type == SKHelperTypeNoMascot) {
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_cardImageView.mas_left).offset(16);
                make.top.equalTo(_cardImageView.mas_bottom).offset(3);
                make.right.equalTo(_cardImageView.mas_right).offset(-16);
            }];
        }
        
        _nextstepButton = [UIButton new];
        [_nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_next"] forState:UIControlStateNormal];
        [_nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_next_highlight"] forState:UIControlStateHighlighted];
        [self addSubview:_nextstepButton];
        
        [_nextstepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@42);
            make.width.equalTo(@42);
            make.centerY.equalTo(cardView.mas_bottom);
            make.right.equalTo(cardView.mas_right).offset(-12);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image andText:(NSString *)text {
    _playBackView.hidden = YES;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _textLabel.attributedText = attributedString;
    [_textLabel sizeToFit];
    _cardImageView.image = image;
}

- (void)setVideoName:(NSString *)videoName andText:(NSString *)text {
    _cardImageView.hidden = YES;
    //视频
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    NSURL *localUrl = [[NSBundle mainBundle] URLForResource:videoName withExtension:@"mp4"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.frame = _playBackView.frame;
    [_playBackView.layer addSublayer:_playerLayer];
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"btn_home_replay"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"btn_home_replay_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = _playBackView.center;
    [_playBackView addSubview:_playButton];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
    
    //文字
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _textLabel.attributedText = attributedString;
    [_textLabel sizeToFit];
}

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    [self stop];
}

#pragma mark - Actions
- (void)stop {
    _playButton.hidden = NO;
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

- (void)pause {
    _playButton.hidden = YES;
    [_player pause];
}

- (void)play {
    _playButton.hidden = YES;
    [_player play];
}

- (void)replay {
    [_player seekToTime:CMTimeMake(0, 1)];
    [self play];
}

- (BOOL)isDisplayedInScreen {
    if (self == nil) {
        return FALSE;
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    return TRUE;
}

#pragma mark - Actions

- (void)nextstepButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickNextStepButtonInView:type:index:)]) {
        [self.delegate didClickNextStepButtonInView:self type:_type index:_index];
    }
}

@end



@interface  SKHelperScrollView () <UIScrollViewDelegate>

@end

@implementation SKHelperScrollView

- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperScrollViewType)type {
    if (self = [super initWithFrame:frame]) {
        [self createUIWithType:type];
    }
    return self;
}

- (void)createUIWithType:(SKHelperScrollViewType)type {
    _dimmingView = [[UIView alloc] initWithFrame:self.frame];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.alpha = 0.9;
    [self addSubview:_dimmingView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    if (type == SKHelperScrollViewTypeQuestion) {
        NSArray *textArray = @[@"“我是零仔〇，住在529D星球”",
                               @"“这个星球除了我，其他同族都离奇的失踪了”",
                               @"“追寻同族留下的线索，我来到了你们的世界”",
                               @"“请留意视频，破解谜团，帮我找到其他零仔”"];
        NSArray *videoArray = @[@"trailer_1", @"trailer_2", @"trailer_3", @"trailer_4"];
        NSInteger pageNumber = textArray.count;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNumber, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        for (int i= 0; i<pageNumber; i++) {
            SKHelperView *helpView = [[SKHelperView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperTypeHasMascot index:i];
            helpView.tag = i+200;
            helpView.backgroundColor = [UIColor clearColor];
            [_scrollView addSubview:helpView];
            if (i == pageNumber-1) {
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete"] forState:UIControlStateNormal];
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete_highlight"] forState:UIControlStateHighlighted];
                [helpView.nextstepButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                helpView.nextstepButton.tag = i+100;
                [helpView.nextstepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [helpView setVideoName:videoArray[i] andText:textArray[i]];
            if (i==0) {
                [helpView play];
            }else {
                [helpView stop];
            }
        }
    } else if (type == SKHelperScrollViewTypeTimeLimitQuestion) {
        NSArray *textArray = @[@"在九零APP里，每一个关卡，每一段视频，每一个文字都可能成为线索！",
                               @"1011010会是线索吗？代表音符？二进制？还是蔡依林？",
                               @"最可能的答案是二进制！1011010对应的十进制就是90",
                               @"验证你的推论，输入90，闯关成功！"];
        NSArray *videoArray = @[@"guide_1", @"guide_2", @"guide_3", @"guide_4"];
//        NSArray *videoArray = @[@"guide_1", @"guide_2", @"guide_3", @"guide_4"];
        NSInteger pageNumber = textArray.count;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNumber, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        for (int i= 0; i<pageNumber; i++) {
            SKHelperView *helpView = [[SKHelperView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperTypeNoMascot index:i];
            helpView.tag = i+200;
            helpView.backgroundColor = [UIColor clearColor];
            [_scrollView addSubview:helpView];
            if (i == pageNumber-1) {
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete"] forState:UIControlStateNormal];
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete_highlight"] forState:UIControlStateHighlighted];
                [helpView.nextstepButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                helpView.nextstepButton.tag = i+100;
                [helpView.nextstepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [helpView setVideoName:videoArray[i] andText:textArray[i]];
            if (i==0) {
                [helpView play];
            }else {
                [helpView stop];
            }
        }
    } else if (type == SKHelperScrollViewTypeMascot) {
        NSArray *textArray = @[@"帮助零仔〇找到失落在地球上的其他零仔们",
                               @"点击零仔头顶的手指去发现这个星球上最九零的人、物、事",
                               @"破解重重关卡，你将解锁更多的研究报告"];
        NSArray *imgArray  = @[@"img_introduce_lingzaipage_1",
                               @"img_introduce_lingzaipage_2",
                               @"img_introduce_lingzaipage_3"
                               ];
        NSInteger pageNumber = textArray.count;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNumber, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        for (int i= 0; i<pageNumber; i++) {
            SKHelperView *helpView = [[SKHelperView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperTypeNoMascot index:i];
            helpView.tag = i+200;
            [_scrollView addSubview:helpView];
            if (i == pageNumber-1) {
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete"] forState:UIControlStateNormal];
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete_highlight"] forState:UIControlStateHighlighted];
                [helpView.nextstepButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                helpView.nextstepButton.tag = i+100;
                [helpView.nextstepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [helpView setImage:[UIImage imageNamed:imgArray[i]] andText:textArray[i]];
        }
    } else if (type == SKHelperScrollViewTypeAR) {
        NSArray *textArray = @[@"本关为线下关卡，你需要去往户外，根据线索提示，发现并捕捉周边的零仔"];
        NSArray *imgArray  = @[@"img_introduce_ar"];
        NSInteger pageNumber = textArray.count;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNumber, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        for (int i= 0; i<pageNumber; i++) {
            SKHelperView *helpView = [[SKHelperView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperTypeNoMascot index:i];
            helpView.tag = i+200;
            [_scrollView addSubview:helpView];
            if (i == pageNumber-1) {
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete"] forState:UIControlStateNormal];
                [helpView.nextstepButton setImage:[UIImage imageNamed:@"btn_introduce_complete_highlight"] forState:UIControlStateHighlighted];
                [helpView.nextstepButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                helpView.nextstepButton.tag = i+100;
                [helpView.nextstepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [helpView setImage:[UIImage imageNamed:imgArray[i]] andText:textArray[i]];
        }

    }
}

#pragma mark - Actions

- (void)nextStepButtonClick:(UIButton *)sender {
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(sender.tag+1-100), 0) animated:YES];
    [(SKHelperView*)[self viewWithTag:sender.tag+100] stop];
    [(SKHelperView*)[self viewWithTag:sender.tag+1+100] play];
}

- (void)completeButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT-356)/2, 0, 0);
        _dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didClickCompleteButton)]) {
            [self.delegate didClickCompleteButton];
        }
    }];
}

#pragma mark - UIScrollView Delegate



@end



@interface SKHelperGuideView ()

@property (nonatomic, assign) SKHelperGuideViewType  type;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@end

@implementation SKHelperGuideView

- (instancetype)initWithFrame:(CGRect)frame withType:(SKHelperGuideViewType)type {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self createUIWithType:type];
    }
    return self;
}

- (void)createUIWithType:(SKHelperGuideViewType)type {
    //step.1
    _view1 = [[UIView alloc] initWithFrame:self.frame];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:_view1.frame];
    imageView1.image = [UIImage imageNamed:@"coach_mark_1"];
    [_view1 addSubview:imageView1];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_guide_know"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"btn_guide_know_highlight"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(onClickTurnToView2) forControlEvents:UIControlEventTouchUpInside];
    [button1 sizeToFit];
    button1.centerX = _view1.centerX;
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        button1.bottom = _view1.bottom - 84;
        button1.left = _view1.left + 141.5;
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        button1.bottom = _view1.bottom - 103.5;
        button1.left =  _view1.left + 141;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        button1.bottom = _view1.bottom - 108;
        button1.left = _view1.left + 180.7;
    }

    [_view1 addSubview:button1];
    
    //step.2
    _view2 = [[UIView alloc] initWithFrame:self.frame];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:_view2.frame];
    imageView2.image = [UIImage imageNamed:@"coach_mark_2"];
    [_view2 addSubview:imageView2];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"btn_guide_know"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"btn_guide_know_highlight"] forState:UIControlStateHighlighted];
    [button2 addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 sizeToFit];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        button2.right = _view2.right - 124.5;
        button2.bottom = _view2.bottom - 84;
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        button2.right = _view2.right - 127;
        button2.bottom = _view2.bottom - 103.5;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        button2.right = _view2.right - 123;
        button2.bottom = _view2.bottom - 108;
    }
    [_view2 addSubview:button2];
    
    //step.3
    _view3 = [[UIView alloc] initWithFrame:self.frame];
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:_view3.frame];
    imageView3.image = [UIImage imageNamed:@"coach_mark_3"];
    [_view3 addSubview:imageView3];
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setImage:[UIImage imageNamed:@"btn_guide_know"] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:@"btn_guide_know_highlight"] forState:UIControlStateHighlighted];
//    [_button3 addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 sizeToFit];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        _button3.top = _view3.top + 163;
        _button3.right = _view3.right - 160.5;
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        _button3.top = _view3.top + 189;
        _button3.right = _view3.right - 209.5;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        _button3.top = _view3.top + 206.7;
        _button3.right = _view3.right - 201.3;
    }
    [_view3 addSubview:_button3];

    //step.4
    _view4 = [[UIView alloc] initWithFrame:self.frame];
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:_view4.frame];
    imageView4.image = [UIImage imageNamed:@"coach_mark_4"];
    [_view4 addSubview:imageView4];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setImage:[UIImage imageNamed:@"btn_guide_know"] forState:UIControlStateNormal];
    [button4 setImage:[UIImage imageNamed:@"btn_guide_know_highlight"] forState:UIControlStateHighlighted];
    [button4 addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button4 sizeToFit];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        button4.top = _view3.top + 121.5;
        button4.right = _view3.right - 122;
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        button4.top = _view3.top + 131.5;
        button4.right = _view3.right - 172;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        button4.top = _view3.top + 148.7;
        button4.right = _view3.right - 189.7;
    }
    UIImageView *buttonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_help_highlight"]];
    [buttonImage sizeToFit];
    buttonImage.frame = CGRectMake(10, 10, 40, 40);
    [_view4 addSubview:buttonImage];
    [_view4 addSubview:button4];

    switch (type) {
        case SKHelperGuideViewType1:{
            [self addSubview:_view1];
            [self addSubview:_view2];
            _view1.alpha = 1;
            _view2.alpha = 0;
            break;
        }
        case SKHelperGuideViewType2:{
            [self addSubview:_view3];
            _view3.alpha = 1;
            break;
        }
        case SKHelperGuideViewType3:{
            [self addSubview:_view4];
            _view1.alpha = 1;
            break;
        }
        default:
            break;
    }
}

- (void)onClickTurnToView2 {
    [UIView animateWithDuration:0.3 animations:^{
        _view1.alpha = 0;
        _view2.alpha = 1;
        _view3.alpha = 0;
        _view4.alpha = 0;
    }];
}

- (void)completeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
