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
#import "HTUIHeader.h"
#import "LTInfiniteScrollView.h"

/* 这个界面长这样:
                ---------------------------------
                |               |               |
                |               |  pageWidth    |
                |               |               |
                | hint | margin | index0 margin |
                |      |                        |
                |      |       self.frame       |
                |      |                        |
                |-------------------------------|
                |                               |
                |        SCREEN_WIDTH           |
                |                               |
                ---------------------------------
*/
typedef NS_ENUM(NSUInteger, HTScrollDirection) {
    HTScrollDirectionLeft,
    HTScrollDirectionRight,
    HTScrollDirectionUnknown,
};

static CGFloat kTopMargin = 0;
static CGFloat kItemMargin = 17;         // item之间间隔

@interface HTPreviewView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *previewScrollView;
@property (nonatomic, strong) NSMutableArray<HTPreviewItem *> *previewItems;
@property (nonatomic, strong) NSArray<HTQuestion *> *questions;

@end

@implementation HTPreviewView {
    CGFloat pageWidth; // 每页宽度
    CGFloat itemWidth; // 显示控件的宽度
    HTScrollDirection _scrollDirection;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *> *)questions {
    if (self = [super initWithFrame:frame]) {
        _questions = questions;
        pageWidth = CGRectGetWidth(frame) - kItemMargin;
        itemWidth = CGRectGetWidth(frame) - kItemMargin * 2;
        
        // 1.滚动视图
        _previewScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _previewScrollView.backgroundColor = [UIColor clearColor];
        _previewScrollView.contentSize = CGSizeMake(pageWidth * questions.count + kItemMargin /* 最右边那个预留宽度 */, self.height);
        _previewScrollView.delegate = self;
        _previewScrollView.pagingEnabled = NO;
        _previewScrollView.clipsToBounds = NO;
        _previewScrollView.showsHorizontalScrollIndicator = NO;
        _previewScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        _previewScrollView.decelerationRate = 0;
        [self addSubview:_previewScrollView];
        [_previewScrollView setContentOffset:CGPointMake([self contentOffsetWithIndex:questions.count - 1], 0)];
        
        // 2.预览视图单元
        _previewItems = [NSMutableArray array];
        for (int i = 0; i != _questions.count; i++) {
            HTPreviewItem *item = [[HTPreviewItem alloc] init];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HTPreviewItem" owner:self options:nil];
            item = [nibs objectAtIndex:0];
            // TODO: 测试代码
            if (i != _questions.count - 1) {
                if (i == _questions.count - 2) {
                    [item setBreakSuccess:YES];
                } else {
                    [item setBreakSuccess:NO];
                }
            }
            // end
            
            item.tag = i;   // 通过tag值来控制view
            [item setQuestion:_questions[_questions.count - i - 1]]; // 倒着取
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
        item.frame = CGRectMake([self contentOffsetWithIndex:item.tag] + kItemMargin /* 最左边还有一个偏移 */, kTopMargin, itemWidth, self.height - kTopMargin);
    }
}

#pragma mark - Public Method

- (void)goToToday {
    [_previewScrollView setContentOffset:CGPointMake([self contentOffsetWithIndex:_questions.count - 1], 0) animated:YES];
}

- (void)setQuestionInfo:(HTQuestionInfo *)questionInfo {
    // TODO:test code
    [_previewItems.lastObject setEndTime:questionInfo.endTime];
//    for (HTPreviewItem *item in _previewItems) {
//        if (item.question.questionID == questionInfo.questionID) {
//            // 当前题目关卡
//            item.endTime = questionInfo.endTime;
//        }
//    }
    
}

- (NSArray<HTPreviewItem *> *)items {
    _items = [NSArray arrayWithArray:_previewItems];
    return _items;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self indexWithContentOffsetX:scrollView.contentOffset.x];
//    _questions[currentIndex]
    if (currentIndex == _questions.count - 4) {
        [self.delegate previewView:self shouldShowGoBackItem:YES];
    }
    if (currentIndex == _questions.count - 3) {
        [self.delegate previewView:self shouldShowGoBackItem:NO];
    }
    static CGFloat preContentOffsetX = 0.0;
    _scrollDirection = (scrollView.contentOffset.x > preContentOffsetX) ? HTScrollDirectionLeft : HTScrollDirectionRight;
    preContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat currentContentOffsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = [self indexWithContentOffsetX:currentContentOffsetX];
    CGFloat indexOffsetX = [self contentOffsetWithIndex:currentIndex];
    CGFloat indexPageCenter = [self pageCenterWithIndex:currentIndex];
    CGFloat targetOffsetX = 0;
    if (_scrollDirection == HTScrollDirectionRight) {
        if (indexPageCenter > indexOffsetX) targetOffsetX = indexOffsetX;
        else targetOffsetX = [self contentOffsetWithIndex:currentIndex + 1];
    } else {
        if (indexPageCenter > indexOffsetX) targetOffsetX = [self contentOffsetWithIndex:currentIndex + 1];
        else targetOffsetX = indexOffsetX;
    }
    *targetContentOffset = CGPointMake(targetOffsetX, 0);
    [self.delegate previewView:self didScrollToItem:_items[[self indexWithContentOffsetX:targetOffsetX]]];
}

#pragma mark - Action

- (NSInteger)indexWithContentOffsetX:(CGFloat)contentOffsetX {
    if (contentOffsetX >= (_previewScrollView.contentSize.width - kItemMargin)) return NSNotFound;
    if (contentOffsetX <= 0) return 0;
    return floor(contentOffsetX / pageWidth);
}

- (CGFloat)pageCenterWithIndex:(NSInteger)index {
    if (index >= _questions.count) return 0;
    return [self contentOffsetWithIndex:index] + pageWidth * 0.5;
}

- (CGFloat)contentOffsetWithIndex:(NSInteger)index {
    if (index >= _questions.count) index = _questions.count - 1;
    if (index <= 0) index = 0;
    return _previewScrollView.contentSize.width -  pageWidth * (_questions.count - index) - kItemMargin /* 右边预留一个margin */;
}

@end
