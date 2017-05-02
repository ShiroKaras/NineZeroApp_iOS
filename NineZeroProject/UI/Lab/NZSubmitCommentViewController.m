//
//  NZSubmitCommentViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/2.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZSubmitCommentViewController.h"
#import "HTUIHeader.h"

@interface NZSubmitCommentViewController ()
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView  *textView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel     *placeholderLabel;
@property (nonatomic, strong) UILabel     *wordCountLabel;
@end

@implementation NZSubmitCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_opinionpage_down"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_opinionpage_down_highlight"] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    [self.view addSubview:backButton];
    backButton.top = 28;
    backButton.left = 13.5;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(8, 64+8, SCREEN_WIDTH-16, 205)];
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 4, backView.width-16, 200)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = PINGFANG_FONT_OF_SIZE(16);
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.tintColor = COMMON_GREEN_COLOR;
    [backView addSubview:_textView];
    
    _placeholderLabel = [UILabel new];
    _placeholderLabel.text = @"留下我的见解...";
    _placeholderLabel.textColor = COMMON_TEXT_3_COLOR;
    _placeholderLabel.font = PINGFANG_FONT_OF_SIZE(16);
    [_placeholderLabel sizeToFit];
    [backView addSubview:_placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(12);
        make.top.equalTo(backView).offset(12);
    }];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 42, self.view.width, 42)];
    _submitButton.layer.masksToBounds = YES;
    self.submitButton.enabled = [self isSubmitButtonValid];
    [self setButtonDisabled];
    [_submitButton addTarget:self action:@selector(onClickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    _wordCountLabel = [UILabel new];
    _wordCountLabel.text = @"剩余字数140";
    _wordCountLabel.textColor = COMMON_TEXT_2_COLOR;
    _wordCountLabel.font = PINGFANG_FONT_OF_SIZE(10);
    [_wordCountLabel sizeToFit];
    [self.view addSubview:_wordCountLabel];
    _wordCountLabel.right = self.view.right - 16;
    _wordCountLabel.bottom = _submitButton.top - 16;
    
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

- (void)setButtonAvailable {
    [_submitButton setImage:[UIImage imageNamed:@"img_opinionpage_release_highlight"] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:COMMON_GREEN_COLOR];
}

- (void)setButtonDisabled {
    [_submitButton setImage:[UIImage imageNamed:@"img_opinionpage_release"] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:COMMON_SEPARATOR_COLOR];
}

- (void)textFieldTextDidChanged:(NSNotification *)notication {
    self.submitButton.enabled = [self isSubmitButtonValid];
    if ([self isSubmitButtonValid]) {
        [self setButtonAvailable];
    } else {
        [self setButtonDisabled];
    }
}

- (void)textViewTextDidChanged:(NSNotification *)notification {
    _wordCountLabel.text = [NSString stringWithFormat:@"剩余字数%ld", 140 -_textView.text.length];
    
    if (_textView.text.length > 140) {
        _textView.text = [_textView.text substringToIndex:140];
    }
    
    self.placeholderLabel.hidden = (self.textView.text.length != 0);
    self.submitButton.enabled = [self isSubmitButtonValid];
    if ([self isSubmitButtonValid]) {
        [self setButtonAvailable];
    } else {
        [self setButtonDisabled];
    }
}

- (BOOL)isSubmitButtonValid {
    if (self.textView.text.length != 0) {
        return YES;
    }
    return NO;
}

- (void)onClickSubmit:(UIButton *)sender {
    self.submitButton.enabled = NO;
    if ([self isSubmitButtonValid]) {
        [self setButtonAvailable];
    } else {
        [self setButtonDisabled];
    }
    [self.view endEditing:YES];
//    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"反馈中"];
//    [[[SKServiceManager sharedInstance] profileService] feedbackWithContent:self.textView.text contact:self.textField.text completion:^(BOOL success, SKResponsePackage *response) {
//        if (success && response.result == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
//            [MBProgressHUD bwm_showTitle:@"感谢反馈" toView:KEY_WINDOW hideAfter:1.0];
//        }
//    }];
}

#pragma mark - Actions

- (void)backButtonClick:(UIButton*)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _submitButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 42, self.view.width, 42);
    _wordCountLabel.right = self.view.right - 16;
    _wordCountLabel.bottom = _submitButton.top - 16;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _submitButton.frame = CGRectMake(0, self.view.height - 42, self.view.width, 42);
    _wordCountLabel.right = self.view.right - 16;
    _wordCountLabel.bottom = _submitButton.top - 16;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
