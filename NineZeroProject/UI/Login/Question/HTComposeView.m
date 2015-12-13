//
//  HTComposeView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/13.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTComposeView.h"
#import "HTUIHeader.h"

@interface HTComposeView () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField; ///< 输入框
@property (nonatomic, strong) UIView *textFieldBackView;         ///< 输入框背景
@property (nonatomic, strong) UIButton *composeButton;           ///< 输入按钮
@property (nonatomic, strong) UIImageView *resultImageView;      ///< 显示结果
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
        [self addSubview:_composeButton];
        
        // 3. 答题框
        _textFieldBackView = [[UIView alloc] init];
        _textFieldBackView.backgroundColor = [UIColor colorWithHex:0x1a1a1a];
        [self insertSubview:_textFieldBackView belowSubview:_composeButton];
        
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.textColor = [UIColor colorWithHex:0x24ddb2];
        [_textFieldBackView addSubview:_textField];
        
        // 4. 结果
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.hidden = YES;
        [self addSubview:_resultImageView];
        
        // 5. 提示
        _tipsBackView = [[UIView alloc] init];
        _tipsBackView.backgroundColor = [UIColor colorWithHex:0x040e88];
        [self addSubview:_tipsBackView];
        
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:16];
        _tipsLabel.textColor = [UIColor whiteColor];
        [_tipsBackView addSubview:_tipsLabel];
        
        // 6. 建立约束
        [self buildConstraints];
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
    
}

#pragma mark - Public Method

- (void)showAnswerTips:(NSString *)tips {

}

- (void)showAnswerCorrect:(BOOL)correct {
    
}

- (BOOL)becomeFirstResponder {
    [_textField becomeFirstResponder];
    return YES;
}

#pragma mark - Tool Method

- (void)didTapDimmingView {
    
}

@end
