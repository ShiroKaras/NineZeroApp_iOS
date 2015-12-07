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
    
    self.previewView = [[HTPreviewView alloc] initWithFrame:CGRectZero andQuestions:nil];
    [self.view addSubview:self.previewView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.previewView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 100);
}

@end
