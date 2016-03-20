//
//  HTPreviewCardController.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTPreviewCardController.h"
#import "HTCardTimeView.h"
#import "HTCardCollectionCell.h"
#import "HTUIHeader.h"
#import "HTQuestionHelper.h"
#import "HTComposeView.h"
#import "HTDescriptionView.h"
#import "HTShowDetailView.h"
#import "HTShowAnswerView.h"
#import "HTARCaptureController.h"
#import "AppDelegate.h"
#import "HTRewardController.h"
#import "Reachability.h"
#import "SharkfoodMuteSwitchDetector.h"

typedef NS_ENUM(NSUInteger, HTScrollDirection) {
    HTScrollDirectionLeft,
    HTScrollDirectionRight,
    HTScrollDirectionUnknown,
};

static CGFloat kItemMargin = 17;         // item之间间隔

@interface HTPreviewCardController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HTCardCollectionCellDelegate, HTARCaptureControllerDelegate, HTComposeViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (nonatomic, strong) HTCardTimeView *timeView;
@property (nonatomic, strong) UIImageView *chapterImageView;
@property (nonatomic, strong) UILabel *chapterLabel;

@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) HTDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) HTShowDetailView *showDetailView;               // 提示详情
@property (strong, nonatomic) HTShowAnswerView *showAnswerView;               // 查看答案

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic,strong) SharkfoodMuteSwitchDetector* detector;
@property (nonatomic, assign) HTPreviewCardType cardType;
@end

@implementation HTPreviewCardController {
    CGFloat itemWidth; // 显示控件的宽度
    HTQuestionInfo *questionInfo;
    NSMutableArray<HTQuestion *> *questionList;
    HTScrollDirection _scrollDirection;
}

- (instancetype)init {
    return [self initWithType:HTPreviewCardTypeDefault];
}

- (instancetype)initWithType:(HTPreviewCardType)type {
    if (self = [super init]) {
        _cardType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    questionList = [NSMutableArray array];
    
    self.view.backgroundColor = UIColorMake(14, 14, 14);
    questionInfo = [HTQuestionHelper questionInfoFake];
//    questionList = [[HTQuestionHelper questionFake] mutableCopy];
    
    itemWidth = SCREEN_WIDTH - 13 - kItemMargin * 2;
    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *callbackQuestionInfo) {
        if (success) {
            questionInfo = callbackQuestionInfo;
            [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:20 callback:^(BOOL success2, NSArray<HTQuestion *> *callbackQuestionList) {
                if (success2) {
                    NSInteger count = questionList.count;
                    for (HTQuestion *question in callbackQuestionList) {
                        [questionList insertObject:question atIndex:count];
                    }
                    [self.collectionView reloadData];
                    [self.collectionView performBatchUpdates:^{}
                                                  completion:^(BOOL finished) {
                                                      [self backToToday:NO];
                                                  }];
                }
            }];
        }
    }];
    
    // 1. 背景
    UIImage *bgImage;
    if (SCREEN_WIDTH <= IPHONE5_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_640×1136"];
    } else if (SCREEN_WIDTH >= IPHONE6_PLUS_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_1242x2208"];
    } else {
        bgImage = [UIImage imageNamed:@"bg_success_750x1334"];
    }
    _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    _bgImageView.hidden = YES;
    [self.view addSubview:_bgImageView];
    
    // 2. 卡片流
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.decelerationRate = 0;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView registerClass:[HTCardCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([HTCardCollectionCell class])];
    [self.view addSubview:_collectionView];
    
    // 3. 右上角倒计时
    _timeView = [[HTCardTimeView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_timeView];
    
    // 4. 左上角章节
    _chapterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chapter"]];
    [self.view addSubview:_chapterImageView];
    
    _chapterLabel = [[UILabel alloc] init];
    _chapterLabel.text = [NSString stringWithFormat:@"%02lu", questionList.lastObject.serial];
    _chapterLabel.font = MOON_FONT_OF_SIZE(14);
    _chapterLabel.textColor = COMMON_PINK_COLOR;
    [_chapterLabel sizeToFit];
    [self.view addSubview:_chapterLabel];
    [self.view sendSubviewToBack:_chapterImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.detector = [SharkfoodMuteSwitchDetector shared];
    __weak typeof(self) weakSelf = self;
    self.detector.silentNotify = ^(BOOL silent){
        if (weakSelf == nil) return;
        typeof(self) strongSelf = weakSelf;
        for (HTCardCollectionCell *cell in strongSelf->_collectionView.visibleCells) {
            [cell setSoundHidden:!silent];
        }
    };
    
    // 5.关闭按钮
    if (_cardType == HTPreviewCardTypeRecord) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
        [_closeButton sizeToFit];
        [_closeButton addTarget:self action:@selector(onClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView performBatchUpdates:^{}
                                      completion:^(BOOL finished) {
                                          [self backToToday:NO];
                                      }];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.cardType == HTPreviewCardTypeDefault) {
        // fix布局bug
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeView.size = CGSizeMake(150, ROUND_HEIGHT_FLOAT(96));
    _timeView.right = SCREEN_WIDTH - kItemMargin;
    _timeView.bottom = ROUND_HEIGHT_FLOAT(96) - 7;
    
    _chapterImageView.left = 30;
    _chapterImageView.top = ROUND_HEIGHT_FLOAT(62);
    _chapterLabel.top = _chapterImageView.top + 6.5;
    _chapterLabel.right = _chapterImageView.left + 46;
    
    _bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:_bgImageView];
    
    _closeButton.bottom = self.view.height - 25;
    _closeButton.centerX = self.view.width / 2;
}

- (void)backToToday {
    [self backToToday:YES];
}

- (void)backToToday:(BOOL)animated {
    _chapterLabel.text = [NSString stringWithFormat:@"%02lu", questionList.lastObject.serial];
    [_collectionView setContentOffset:CGPointMake([self contentOffsetWithIndex:questionList.count - 1], 0) animated:animated];
    [_timeView setQuestion:questionList.lastObject andQuestionInfo:questionInfo];
}

- (void)onClickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardRect.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_composeView removeFromSuperview];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return questionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTCardCollectionCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    HTQuestion *question = questionList[indexPath.row];
    [cell setQuestion:question questionInfo:questionInfo];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = SCREEN_WIDTH - 47;
    return CGSizeMake(width, SCREEN_HEIGHT - ROUND_HEIGHT_FLOAT(96));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kItemMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(ROUND_HEIGHT_FLOAT(96), 30, 0, kItemMargin);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HTCardCollectionCell *)cell stop];
}

#pragma mark - HTCardCollectionCellDelegate

- (void)onClickedPlayButtonInCollectionCell:(HTCardCollectionCell *)cell {
    for (HTCardCollectionCell *iter in [_collectionView visibleCells]) {
        if (cell != iter) {
            [iter stop];
        }
    }
}

- (void)collectionCell:(HTCardCollectionCell *)cell didClickButtonWithType:(HTCardCollectionClickType)type {
    switch (type) {
        case HTCardCollectionClickTypeAnswer: {
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [[appDelegate mainController] showBottomButton:NO];
            _showAnswerView = [[HTShowAnswerView alloc] initWithURL:cell.question.detailURL];
            _showAnswerView.alpha = 0.0;
            _showAnswerView.frame = self.view.bounds;
            
            [UIView animateWithDuration:0.3 animations:^{
                _showAnswerView.alpha = 1.0f;
                [self.view addSubview:_showAnswerView];
            }];
            
            break;
        }
        case HTCardCollectionClickTypeHint: {
            _showDetailView = [[HTShowDetailView alloc] initWithDetailText:cell.question.hint andShowInRect:[cell convertRect:[cell hintRect] toView:self.view]];
            _showDetailView.frame = self.view.bounds;
            _showDetailView.alpha = 0.0;
            [self.view addSubview:_showDetailView];
            [UIView animateWithDuration:0.3 animations:^{
                _showDetailView.alpha = 1.0;
            }];
            break;
        }
        case HTCardCollectionClickTypeReward: {
            HTRewardController *reward = [[HTRewardController alloc] init];
            reward.view.backgroundColor = [UIColor clearColor];
            if (IOS_VERSION >= 8.0) {
                reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:reward animated:YES completion:nil];
            break;
        }
        case HTCardCollectionClickTypeAR: {
            HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] init];
            arCaptureController.delegate = self;
            [self presentViewController:arCaptureController animated:YES completion:nil];
            break;
        }
        case HTCardCollectionClickTypePause: {
            break;
        }
        case HTCardCollectionClickTypeCompose: {
                _composeView = [[HTComposeView alloc] init];
                _composeView.delegate = self;
                _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                _composeView.alpha = 0.0;
                _composeView.associatedQuestion = cell.question;
                [_composeView becomeFirstResponder];
                [UIView animateWithDuration:0.3 animations:^{
                    _composeView.alpha = 1.0;
                    [self.view addSubview:_composeView];
                } completion:^(BOOL finished) {
                }];
            break;
        }
        case HTCardCollectionClickTypeContent: {
            _descriptionView = [[HTDescriptionView alloc] initWithURLString:cell.question.questionDescription];
            [self.view addSubview:_descriptionView];
            [_descriptionView showAnimated];
            break;
        }
        case HTCardCollectionClickTypePlay: {
            break;
        }
        default:
            break;
    }
}


#pragma mark - HTComposeView Delegate

- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
    [self composeWithAnswer:answer question:composeView.associatedQuestion];
}

- (void)composeWithAnswer:(NSString *)answer question:(HTQuestion *)question {
    static int clickCount = 0;
    _composeView.composeButton.enabled = NO;
    [[[HTServiceManager sharedInstance] questionService] verifyQuestion:question.questionID withAnswer:answer callback:^(BOOL success, HTResponsePackage *response) {
        _composeView.composeButton.enabled = YES;
        if (success) {
            if (response.resultCode == 0) {
                [_composeView showAnswerCorrect:YES];
                clickCount = 0;
                // 获取成功了，开始分刮奖励
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_composeView endEditing:YES];
                    [_composeView removeFromSuperview];
                    HTRewardController *reward = [[HTRewardController alloc] init];
                    reward.view.backgroundColor = [UIColor clearColor];
                    if (IOS_VERSION >= 8.0) {
                        reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    }
                    [self presentViewController:reward animated:YES completion:nil];
                });
            } else {
                if (clickCount >= 3) [_composeView showAnswerTips:[NSString stringWithFormat:@"提示:%@", question.hint]];
                [_composeView showAnswerCorrect:NO];
                clickCount++;
            }
        }
    }];
}

- (void)didClickDimingViewInComposeView:(HTComposeView *)composeView {
    [self.view endEditing:YES];
    [composeView removeFromSuperview];
}


#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller {
    [controller dismissViewControllerAnimated:NO completion:nil];
    HTRewardController *reward = [[HTRewardController alloc] init];
    reward.view.backgroundColor = [UIColor clearColor];
    if (IOS_VERSION >= 8.0) {
        reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:reward animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self indexWithContentOffsetX:scrollView.contentOffset.x];
//    _questions[currentIndex]
    if (self.cardType == HTPreviewCardTypeDefault) {
        if (currentIndex == questionList.count - 4) {
            [[HTUIHelper mainController] showBackToToday:YES];
        }
        if (currentIndex == questionList.count - 3) {
            [[HTUIHelper mainController] showBackToToday:NO];
        }
        
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
//    [self.delegate previewView:self didScrollToItem:_items[[self indexWithContentOffsetX:targetOffsetX]]];
    NSInteger targetIndex = [self indexWithContentOffsetX:targetOffsetX];
    [self willAppearQuestionAtIndex:targetIndex];
}

#pragma mark - Action

- (void)willAppearQuestionAtIndex:(NSInteger)index {
    if (index < 0 || index > questionList.count) return;
    _chapterLabel.text = [NSString stringWithFormat:@"%02lu", questionList[index].serial];
    [_timeView setQuestion:questionList[index] andQuestionInfo:questionInfo];
    // 背景
    if (questionList[index].isPassed) {
        _bgImageView.hidden = NO;
        _bgImageView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            _bgImageView.alpha = 1.0;
        }];
    } else {
        _bgImageView.hidden = YES;
    }
    
    // wifi
    Reachability *reach = [Reachability reachabilityForLocalWiFi];
    if ([reach currentReachabilityStatus] != NotReachable) {
        // 开启了wifi
        for (HTCardCollectionCell *cell in _collectionView.visibleCells) {
            if (cell.question.questionID != questionList[index].questionID) {
                [cell stop];
            } else {
                [cell play];
            }
        }
    }
}

- (NSInteger)indexWithContentOffsetX:(CGFloat)contentOffsetX {
    if (contentOffsetX >= (_collectionView.contentSize.width - kItemMargin)) return NSNotFound;
    if (contentOffsetX <= 0) return 0;
    return floor(contentOffsetX / (itemWidth + kItemMargin));
}

- (CGFloat)pageCenterWithIndex:(NSInteger)index {
    if (index >= questionList.count) return 0;
    return [self contentOffsetWithIndex:index] + (itemWidth + kItemMargin) * 0.5;
}

- (CGFloat)contentOffsetWithIndex:(NSInteger)index {
    if (index >= questionList.count) index = questionList.count - 1;
    if (index <= 0) index = 0;
    return (self.view.width - kItemMargin - 13) * index;
}

@end
