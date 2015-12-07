//
//  HTPreviewQuestionController.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTPreviewQuestionController.h"
#import "HTPreviewItem.h"
#import "HTPreviewView.h"
#import "CommonUI.h"

static CGFloat kLeftMargin = 13; // 暂定为0

@interface HTPreviewQuestionController ()

@property (weak, nonatomic) IBOutlet UIButton *mainButton;                    // 左下角“九零”
@property (weak, nonatomic) IBOutlet UIButton *meButton;                      // 右下角“我”
@property (weak, nonatomic) IBOutlet UIButton *lingzaiButton;                 // 右下角"零仔"
@property (strong, nonatomic) HTPreviewView *previewView;

@end

@implementation HTPreviewQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.previewView = [[HTPreviewView alloc] initWithFrame:CGRectMake(kLeftMargin, 0, self.view.width - kLeftMargin, self.view.height) andQuestions:nil];
    [self.view insertSubview:self.previewView atIndex:0];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

@end
