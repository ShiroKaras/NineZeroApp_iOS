//
//  HTPreviewView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTPreviewView.h"
#import "HTPreviewItem.h"
#import "CommonUI.h"

@interface HTPreviewView() <UIScrollViewDelegate>

@property (nonatomic, strong) HTPreviewItem *previewItem;
@property (nonatomic, strong) UIScrollView *previewScrollView;

@end

@implementation HTPreviewView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *> *)questions {
    if (self = [super initWithFrame:frame]) {
        
        // FIXME:0.构造假数据
//        NSInteger count = 10;
        
        // 1.滚动视图
        _previewScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _previewScrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        _previewScrollView.backgroundColor = [UIColor clearColor];
        _previewScrollView.delegate = self;
        _previewScrollView.pagingEnabled = YES;
        _previewScrollView.showsHorizontalScrollIndicator = NO;
        _previewScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        [self addSubview:_previewScrollView];
        
        // 2.预览视图单元
        _previewItem = [[HTPreviewItem alloc] initWithFrame:frame];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HTPreviewItem" owner:self options:nil];
        _previewItem = [nibs objectAtIndex:0];
        [self addSubview:_previewItem];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrame:CGRectZero andQuestions:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andQuestions:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _previewScrollView.frame = self.bounds;
    _previewItem.frame = self.bounds;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

@end
