//
//  HTPreviewQuestionController.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTPreviewQuestionController.h"

@interface HTPreviewQuestionController ()

@property (weak, nonatomic) IBOutlet UILabel *chapterNumberLabel;             // 第几章
@property (weak, nonatomic) IBOutlet UILabel *countDownBottomLabel;           // 倒计时下面哪个label
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;         // 倒计时上面那个装饰用imageView
@property (weak, nonatomic) IBOutlet UIButton *mainButton;                    // 左下角“九零”
@property (weak, nonatomic) IBOutlet UIButton *meButton;                      // 右下角“我”
@property (weak, nonatomic) IBOutlet UIButton *lingzaiButton;                 // 右下角"零仔"

@end

@implementation HTPreviewQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

@end
