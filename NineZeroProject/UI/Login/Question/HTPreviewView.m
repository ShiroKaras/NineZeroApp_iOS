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

static CGFloat kTopMargin = 50;
static CGFloat kItemMargin = 17;         // item之间间隔

@interface HTPreviewView() <UIScrollViewDelegate, HTPreviewItemDelegate>

@property (nonatomic, strong) UIScrollView *previewScrollView;
@property (nonatomic, strong) NSMutableArray<HTPreviewItem *> *previewItems;

@end

@implementation HTPreviewView {
    CGFloat pageSize;  // 每页宽度
    CGFloat itemWidth; // 显示控件的宽度
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *> *)questions {
    if (self = [super initWithFrame:frame]) {
        
        pageSize = CGRectGetWidth(frame) - kItemMargin;
        itemWidth = CGRectGetWidth(frame) - kItemMargin * 2;
        
        // 1.滚动视图
        _previewScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _previewScrollView.backgroundColor = [UIColor clearColor];
        _previewScrollView.contentSize = CGSizeMake(pageSize * 3 + kItemMargin /* 最右边那个预留宽度 */, self.height);
        _previewScrollView.delegate = self;
        _previewScrollView.pagingEnabled = NO;
        _previewScrollView.clipsToBounds = NO;
        _previewScrollView.showsHorizontalScrollIndicator = NO;
        _previewScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        [self addSubview:_previewScrollView];
        [_previewScrollView setContentOffset:CGPointMake([self contentOffsetWithIndex:0], 0)];
        
        // 2.预览视图单元
        _previewItems = [NSMutableArray array];
        for (int i = 0; i != 3; i++) {
            HTPreviewItem *item = [[HTPreviewItem alloc] init];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HTPreviewItem" owner:self options:nil];
            item = [nibs objectAtIndex:0];
            item.delegate = self;
            [_previewItems addObject:item];
            [_previewScrollView addSubview:item];
        }
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
    for (int i = 0; i != _previewItems.count; i++) {
        HTPreviewItem *item = _previewItems[i];
        item.frame = CGRectMake([self contentOffsetWithIndex:i] + kItemMargin, kTopMargin, itemWidth, self.height - kTopMargin);
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

#pragma mark - HTPreviewItem Delegate

- (void)previewItem:(HTPreviewItem *)previewItem didClickComposeButton:(UIButton *)composeButton {
    if ([self.delegate respondsToSelector:@selector(previewView:didClickComposeWithItem:)]) {
        [self.delegate previewView:self didClickComposeWithItem:previewItem];
    }
}

#pragma mark - Action

- (CGFloat)contentOffsetWithIndex:(NSInteger)index {
    return _previewScrollView.contentSize.width -  pageSize * (index + 1) - kItemMargin;
}

@end
