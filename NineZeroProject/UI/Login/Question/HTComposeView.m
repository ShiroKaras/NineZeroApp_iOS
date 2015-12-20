//
//  HTComposeView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/13.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTComposeView.h"
#import "HTUIHeader.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface HTComposeView () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField; ///< 输入框
@property (nonatomic, strong) UIView *textFieldBackView;         ///< 输入框背景
@property (nonatomic, strong) UIButton *composeButton;           ///< 输入按钮
@property (nonatomic, strong) FLAnimatedImageView *resultImageView;      ///< 显示结果
@property (nonatomic, strong) UILabel *tipsLabel;                ///< 提示
@property (nonatomic, strong) UIView *tipsBackView;              ///< 提示背景
@property (nonatomic, strong) UIView *dimmingView;               ///< 答题背景

@end

@implementation HTComposeView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1. 背景
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:_dimmingView];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDimmingView)];
        tap.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap];
        
        // 2. 答题按钮
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_composeButton setImage:[UIImage imageNamed:@"btn_ans_send"] forState:UIControlStateNormal];
        [_composeButton setImage:[UIImage imageNamed:@"btn_ans_send_highlight"] forState:UIControlStateHighlighted];
        _composeButton.enabled = NO;
        [_composeButton addTarget:self action:@selector(didClickComposeButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_composeButton];
        [_composeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        
        // 3. 答题框
        _textFieldBackView = [[UIView alloc] init];
        _textFieldBackView.backgroundColor = [UIColor colorWithHex:0x1a1a1a];
        [self insertSubview:_textFieldBackView belowSubview:_composeButton];
        
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.placeholder = @"请输入你的答案";
        _textField.textColor = [UIColor colorWithHex:0x24ddb2];
        [_textFieldBackView addSubview:_textField];
        
        // 4. 结果
        _resultImageView = [[FLAnimatedImageView alloc] init];
        _resultImageView.hidden = YES;
        [self addSubview:_resultImageView];
        
        // 5. 提示
        _tipsBackView = [[UIView alloc] init];
        _tipsBackView.backgroundColor = [UIColor colorWithHex:0xd40e88];
        _tipsBackView.hidden = YES;
        [self addSubview:_tipsBackView];
        
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor whiteColor];
        [_tipsBackView addSubview:_tipsLabel];
        
        // 6. 建立约束
        [self buildConstraints];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeText) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)buildConstraints {
    // 1. 背景
    [_dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 2. 答题按钮
    [_composeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-22);
        make.right.equalTo(self.mas_right).offset(-19);
    }];
    
    // 3. 答题框
    [_textFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@42);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textFieldBackView).insets(UIEdgeInsetsMake(3, 16, 3, 16));
    }];
    
    // 4. 结果
    [_resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).centerOffset(CGPointMake(0, -20));
    }];
    
    // 5. 提示
    [_tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.width.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tipsBackView);
    }];
}

- (void)buildResultImageViewWithCorrect:(BOOL)correct {
    [_resultImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (correct == YES) {
            make.width.equalTo(@165);
            make.height.equalTo(@165);
        } else {
            make.width.equalTo(@243);
            make.height.equalTo(@67);
        }
        make.center.equalTo(self).centerOffset(CGPointMake(0, -20));
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method

- (void)showAnswerTips:(NSString *)tips {
    _tipsLabel.text = tips;
    [UIView animateWithDuration:0.3 animations:^{
        _tipsBackView.hidden = NO;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _tipsBackView.hidden = YES;
        });
    }];
}

- (void)showAnswerCorrect:(BOOL)correct {
    _resultImageView.hidden = NO;
    NSString *gifName = (correct) ? @"right-answer_gif" : @"raw_wrong_answer_gif";
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]]];
    image.loopCount = 1;
    _resultImageView.animatedImage = image;
    [self buildResultImageViewWithCorrect:correct];
}

- (BOOL)becomeFirstResponder {
    [_textField becomeFirstResponder];
    return YES;
}

#pragma mark - Action

- (void)didClickComposeButton {
    if ([self.delegate respondsToSelector:@selector(composeView:didComposeWithAnswer:)]) {
        [self.delegate composeView:self didComposeWithAnswer:_textField.text];
    }
}

- (void)textFieldDidChangeText {
    NSString *text = _textField.text;
    _composeButton.enabled = (text.length != 0);
}

#pragma mark - Tool Method

- (void)didTapDimmingView {
    if ([self.delegate respondsToSelector:@selector(didClickDimingViewInComposeView:)]) {
        [self.delegate didClickDimingViewInComposeView:self];
    }
}

@end
