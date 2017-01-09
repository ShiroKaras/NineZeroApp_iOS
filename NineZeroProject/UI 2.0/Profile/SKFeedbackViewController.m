//
//  SKFeedbackViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKFeedbackViewController.h"
#import "HTUIHeader.h"

@interface SKFeedbackViewController ()
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel     *placeholderLabel;
@end

@implementation SKFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"advicepage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"advicepage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"帮助我们进步";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 64+8, SCREEN_WIDTH-20, 205)];
    backView.backgroundColor = COMMON_SEPARATOR_COLOR;
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(10, 144, backView.width-20, 1)];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [backView addSubview:splitLine];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 4, backView.width-16, 144-4)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = PINGFANG_FONT_OF_SIZE(16);
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [backView addSubview:_textView];
    
    _placeholderLabel = [UILabel new];
    _placeholderLabel.text = @"请输入意见和反馈，我们会尽快处理";
    _placeholderLabel.textColor = [UIColor colorWithHex:0x4f4f4f];
    _placeholderLabel.font = PINGFANG_FONT_OF_SIZE(16);
    [_placeholderLabel sizeToFit];
    [backView addSubview:_placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(12);
        make.top.equalTo(backView).offset(12);
    }];
    
    _textField = [UITextField new];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.placeholder = @"请输入联系方式";
    _textField.textColor = [UIColor whiteColor];
    [_textField setValue:[UIColor colorWithHex:0x4f4f4f] forKeyPath:@"_placeholderLabel.textColor"];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 60)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [backView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(backView);
        make.height.equalTo(@60);
        make.bottom.equalTo(backView);
        make.centerX.equalTo(backView);
    }];
    
    _submitButton = [UIButton new];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageWithColor:COMMON_RED_COLOR] forState:UIControlStateHighlighted];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(backView);
        make.height.equalTo(@50);
        make.centerX.equalTo(backView);
        make.top.equalTo(backView.mas_bottom).offset(10);
    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:blankView];
        blankView.top = ROUND_HEIGHT_FLOAT(217);
    }
}

- (void)textFieldTextDidChanged:(NSNotification *)notication {
    self.submitButton.enabled = [self isSubmitButtonValid];
}

- (void)textViewTextDidChanged:(NSNotification *)notification {
    self.placeholderLabel.hidden = (self.textView.text.length != 0);
    self.submitButton.enabled = [self isSubmitButtonValid];
}

- (BOOL)isSubmitButtonValid {
    if (self.textView.text.length != 0 && self.textField.text.length != 0) {
        return YES;
    }
    return NO;
}

- (void)onClickSubmit:(UIButton *)sender {
    self.submitButton.enabled = NO;
    [self.view endEditing:YES];
    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"反馈中"];
    [[[SKServiceManager sharedInstance] profileService] feedbackWithContent:self.textView.text contact:self.textField.text completion:^(BOOL success, SKResponsePackage *response) {
        if (success && response.result == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            [MBProgressHUD bwm_showTitle:@"感谢反馈" toView:KEY_WINDOW hideAfter:1.0];
        }
    }];
}
@end
