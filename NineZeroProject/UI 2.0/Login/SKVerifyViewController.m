//
//  SKVerifyViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKVerifyViewController.h"
#import "HTUIHeader.h"

#import "SKConfirmPasswordViewController.h"

@interface SKVerifyViewController ()

@property (nonatomic, strong) UITextField *verifyCodeTextField;
@property (nonatomic, strong) UIButton *resendVerifyCodeButton;
@property (nonatomic, assign) SKVerifyType type;

@end

@implementation SKVerifyViewController

- (instancetype)initWithType:(SKVerifyType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self createUIWithType:type];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUIWithType:(SKVerifyType)type {
    self.view.backgroundColor = COMMON_PINK_COLOR;
    
    __weak __typeof(self)weakSelf = self;
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    if (type == SKVerifyTypeRegister) {
        UIImageView *stepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_code"]];
        [self.view addSubview:stepImageView];
        [stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@26);
            make.height.equalTo(@26);
            make.top.equalTo(@19);
            make.centerX.equalTo(weakSelf.view.mas_centerX).offset(11);
        }];
        
        UIView *point = [UIView new];
        point.backgroundColor = [UIColor whiteColor];
        point.layer.cornerRadius = 6;
        [self.view addSubview:point];
        [point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@12);
            make.height.equalTo(@12);
            make.right.equalTo(stepImageView.mas_left).offset(-10);
            make.centerY.equalTo(stepImageView.mas_centerY);
        }];
    } else if (type == SKVerifyTypeResetPassword) {
        UIImageView *stepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_code"]];
        [self.view addSubview:stepImageView];
        [stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@26);
            make.height.equalTo(@26);
            make.top.equalTo(@19);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        UIView *point = [UIView new];
        point.backgroundColor = [UIColor whiteColor];
        point.layer.cornerRadius = 6;
        [self.view addSubview:point];
        [point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@12);
            make.height.equalTo(@12);
            make.right.equalTo(stepImageView.mas_left).offset(-10);
            make.centerY.equalTo(stepImageView.mas_centerY);
        }];
        
        UIView *point1 = [UIView new];
        point1.backgroundColor = [UIColor clearColor];
        point1.layer.cornerRadius = 6;
        point1.layer.borderWidth = 2;
        point1.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:point1];
        [point1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@12);
            make.height.equalTo(@12);
            make.left.equalTo(stepImageView.mas_right).offset(10);
            make.centerY.equalTo(stepImageView.mas_centerY);
        }];
    }
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = @"验证码短信马上就来\n28秒后可重新发送";
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 2;
    [contentLabel sizeToFit];
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ROUND_HEIGHT(122));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    for (int i = 0; i<4; i++) {
        UIView *circleView = [UIView new];
        circleView.layer.cornerRadius = 23;
        circleView.backgroundColor = [UIColor colorWithHex:0x97045D];
        [self.view addSubview:circleView];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@46);
            make.height.equalTo(@46);
            make.top.equalTo(contentLabel.mas_bottom).offset(20);
            make.left.equalTo(@((SCREEN_WIDTH-220)/2+i*58));
        }];
        
        UILabel *numberLabel = [UILabel new];
        numberLabel.tag = i+100;
        numberLabel.text = @" ";
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = MOON_FONT_OF_SIZE(32);
        [numberLabel sizeToFit];
        [self.view addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(circleView);
        }];
    }
    
    _resendVerifyCodeButton = [UIButton new];
    _resendVerifyCodeButton.backgroundColor = [UIColor clearColor];
    [_resendVerifyCodeButton setTitle:@"接收短信出问题了？重新发送验证码" forState:UIControlStateNormal];
    _resendVerifyCodeButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
    [self.view addSubview:_resendVerifyCodeButton];
    
    _verifyCodeTextField = [[UITextField alloc] init];
    _verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_verifyCodeTextField];
    [_verifyCodeTextField becomeFirstResponder];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if (_verifyCodeTextField.text.length == 0) {
        ((UILabel*)[self.view viewWithTag:100]).text = @"";
    } else if (_verifyCodeTextField.text.length == 1) {
        ((UILabel*)[self.view viewWithTag:100]).text = [_verifyCodeTextField.text substringWithRange:NSMakeRange(0, 1)];
        ((UILabel*)[self.view viewWithTag:101]).text = @"";
    } else if (_verifyCodeTextField.text.length == 2) {
        ((UILabel*)[self.view viewWithTag:101]).text = [_verifyCodeTextField.text substringWithRange:NSMakeRange(1, 1)];
        ((UILabel*)[self.view viewWithTag:102]).text = @"";
    } else if (_verifyCodeTextField.text.length ==  3) {
        ((UILabel*)[self.view viewWithTag:102]).text = [_verifyCodeTextField.text substringWithRange:NSMakeRange(2, 1)];
        ((UILabel*)[self.view viewWithTag:103]).text = @"";
    } else if (_verifyCodeTextField.text.length == 4) {
        ((UILabel*)[self.view viewWithTag:103]).text = [_verifyCodeTextField.text substringWithRange:NSMakeRange(3, 1)];
        if (_type == SKVerifyTypeResetPassword) {
            SKConfirmPasswordViewController *controller = [[SKConfirmPasswordViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        NSString *string = [_verifyCodeTextField.text substringWithRange:NSMakeRange(0, 4)];
        _verifyCodeTextField.text = string;
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _resendVerifyCodeButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height-50, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _resendVerifyCodeButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
