//
//  SKUserAgreementViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/5/23.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKUserAgreementViewController.h"
#import "HTUIHeader.h"
@interface SKUserAgreementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SKUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.title = @"用户协议";
    _textView.editable = NO;
    _textView.textColor = [UIColor colorWithHex:0xCBCBCB];
    _textView.contentOffset = CGPointMake(0, 0);
//    CGRect textFrame =[[self.textView layoutManager] usedRectForTextContainer:[self.textView textContainer]];
//    _textView.contentSize = textFrame.size;
}

@end
