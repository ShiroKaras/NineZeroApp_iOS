//
//  HTPreviewCardController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/6.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTPreviewCardController.h"
#import "HTCardTimeView.h"
#import "HTCardCollectionCell.h"
#import "HTUIHeader.h"
#import "HTComposeView.h"
#import "HTDescriptionView.h"
#import "HTShowDetailView.h"
#import "HTShowAnswerView.h"
#import "HTARCaptureController.h"
#import "HTRewardController.h"
#import "Reachability.h"
#import "SharkfoodMuteSwitchDetector.h"
#import "JPUSHService.h"
#import "HTRelaxController.h"
#import "HTAlertView.h"
#import "HTBlankView.h"
#import "HTArticleController.h"

#import "SKAnswerDetailView.h"
#import "SKRankInQuestionViewController.h"
#import "SKHelperView.h"

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
@property (nonatomic, strong) HTRecordView *recordView;
@property (nonatomic, strong) UIImageView *chapterImageView;
@property (nonatomic, strong) UILabel *chapterLabel;

@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) HTDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) HTShowDetailView *showDetailView;               // 提示详情
@property (strong, nonatomic) HTShowAnswerView *showAnswerView;               // 查看答案
@property (strong, nonatomic) SKAnswerDetailView *showAnswerDetailView;       // 查看答案详情
@property (strong, nonatomic) SKRankInQuestionViewController *showRankView;    //查看排名

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic,strong) SharkfoodMuteSwitchDetector* detector;
@property (nonatomic, assign) HTPreviewCardType cardType;
@property (nonatomic, strong) UIImageView *eggImageView;
@property (nonatomic, strong) UIImageView *eggCoverImageView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *blankBackView;
@property (nonatomic, strong) HTBlankView *blankView;

@property (nonatomic, strong) UIView *courseView;
@property (nonatomic, strong) SKHelperGuideView *guideView;
@property (nonatomic, strong) UIImageView *courseImageView;
@property (nonatomic, strong) NSMutableArray *courseImageArray;                      //教程图片组
@property (nonatomic, strong) NSMutableArray *courseImageArray_iPhone6;                      //教程图片组iphone6
@property (nonatomic, assign) NSUInteger currentCourseImageIndex;
@property (nonatomic, assign) BOOL isRelaxDay;

@property (nonatomic, strong) UIButton *helpButton;
@end

@implementation HTPreviewCardController {
    CGFloat itemWidth; // 显示控件的宽度
    HTQuestionInfo *questionInfo;
    NSMutableArray<HTQuestion *> *questionList;
    HTScrollDirection _scrollDirection;
}

- (instancetype)initWithType:(HTPreviewCardType)type andQuestList:(NSArray<HTQuestion *> *)questions {
    if (self = [super init]) {
        _cardType = type;
        if (questions != nil) {
            questionList = [questions mutableCopy];
        } else {
            questionList = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)initWithType:(HTPreviewCardType)type andQuestList:(NSArray<HTQuestion *> *)questions questionInfo:(HTQuestionInfo*)info {
    if (self = [super init]) {
        _cardType = type;
        questionInfo = info;
        if (questions != nil) {
            questionList = [questions mutableCopy];
        } else {
            questionList = [NSMutableArray array];
        }
    }
    return self;
}

- (instancetype)init {
    return [self initWithType:HTPreviewCardTypeDefault];
}

- (instancetype)initWithType:(HTPreviewCardType)type {
    return [self initWithType:type andQuestList:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UD boolForKey:@"everLaunched"]) {
        [UD setBool:YES forKey:@"everLaunched"];
        [UD setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [UD setBool:NO forKey:@"firstLaunch"];
    }
    
    self.view.backgroundColor = UIColorMake(14, 14, 14);
    itemWidth = SCREEN_WIDTH - 13 - kItemMargin * 2;
    
    [HTProgressHUD dismiss];
    [self createUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUnreadArticleFlag];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    if (self.cardType == HTPreviewCardTypeDefault) {
        [MobClick beginLogPageView:@"mainpage"];
    }else if (self.cardType == HTPreviewCardTypeRecord) {
        [MobClick beginLogPageView:@"recordpage"];
    }
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[SKAnswerDetailView class]]) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[[HTServiceManager sharedInstance] profileService] updateUserInfoFromSvr];
    if (self.cardType == HTPreviewCardTypeDefault) {
        [MobClick endLogPageView:@"mainpage"];
    }else if (self.cardType == HTPreviewCardTypeRecord) {
        [MobClick endLogPageView:@"recordpage"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
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
    
    _recordView.size = CGSizeMake(150, ROUND_HEIGHT_FLOAT(96));
    _recordView.right = SCREEN_WIDTH - kItemMargin;
    _recordView.bottom = ROUND_HEIGHT_FLOAT(96) - 12;
    
    _chapterImageView.left = 17;
    _chapterImageView.top = ROUND_HEIGHT_FLOAT(64);
    if (SCREEN_WIDTH > IPHONE5_SCREEN_WIDTH) {
        _chapterImageView.top = _chapterImageView.top + 3;
    }
    _chapterLabel.top = _chapterImageView.top + 6.5;
    _chapterLabel.right = _chapterImageView.left + 46;
    
    _bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:_bgImageView];
    
    _closeButton.bottom = self.view.height - 25;
    _closeButton.centerX = self.view.width / 2;
    
    if (_cardType == HTPreviewCardTypeDefault) {
        _eggImageView.left = _collectionView.contentSize.width;
        _eggImageView.centerY = SCREEN_HEIGHT / 2;
    }
    
    [self.view bringSubviewToFront:_dimmingView];
}

- (void)loadData {
    [[[HTServiceManager sharedInstance] profileService] updateProfileInfoFromServer];
    if (_cardType == HTPreviewCardTypeDefault) {
        [HTProgressHUD show];
        _dimmingView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _dimmingView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:_dimmingView];
        
        [[[HTServiceManager sharedInstance] questionService] getIsRelaxDay:^(BOOL success, HTResponsePackage *response) {
            NSString *dictData = [NSString stringWithFormat:@"%@", response.data];
            if (success && response.resultCode == 0) {
                if ([dictData isEqualToString:@"1"]) {
                    [HTProgressHUD dismiss];
                    _isRelaxDay = [dictData boolValue];
                    HTRelaxController *relaxController = [[HTRelaxController alloc] init];
                    [self presentViewController:relaxController animated:NO completion:nil];
                    [self.view bringSubviewToFront:relaxController.view];
                    [self showAlert];
                } else if ([dictData isEqualToString:@"0"]){
                    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *callbackQuestionInfo) {
                        if (success) {
                            questionInfo = callbackQuestionInfo;
                            [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success2, NSArray<HTQuestion *> *callbackQuestionList) {
                                [HTProgressHUD dismiss];
                                [_dimmingView removeFromSuperview];
                                if (success2) {
                                    questionList = [callbackQuestionList mutableCopy];
                                    [self.collectionView reloadData];
                                    [self.collectionView performBatchUpdates:^{}
                                                                  completion:^(BOOL finished) {
                                                                      [self backToToday:NO];
                                                                  }];
                                }
                            }];
                            _eggImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_home_egg"]];
                            [self.collectionView addSubview:_eggImageView];
                            if (FIRST_LAUNCH) {
                                [self showCourseView];
                            } else{
                                [self showAlert];
                            }
                        } else {
                            [HTProgressHUD dismiss];
                            [_dimmingView removeFromSuperview];
                            [self showBlankViewNetWorkError];
                        }
                    }];
                    
                }
            } else {
                [HTProgressHUD dismiss];
                [self showBlankViewNetWorkError];
            }
        }];
        
        if ([[HTStorageManager sharedInstance] getUserID]) {
            [JPUSHService setTags:[NSSet setWithObject:@"iOS"] alias:[[HTStorageManager sharedInstance] getUserID] callbackSelector:nil target:nil];
        }
        
        _timeView = [[HTCardTimeView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_timeView];
        
        _eggCoverImageView = [UIImageView new];
        _eggCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _eggCoverImageView.layer.masksToBounds = YES;
        [[[HTServiceManager sharedInstance] questionService] getCoverPicture:^(BOOL success, HTResponsePackage *response) {
            if (success && response.resultCode == 0) {
                NSDictionary *dataDict = response.data;
                [_eggCoverImageView sd_setImageWithURL:dataDict[@"pet_gif"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
            }
        }];
    } else if (_cardType == HTPreviewCardTypeRecord) {
        questionList = [[[HTStorageManager sharedInstance] profileInfo].answer_list mutableCopy];
        if (questionList.count>0) {
            _recordView = [[HTRecordView alloc] initWithFrame:CGRectZero];
            [self.view addSubview:_recordView];
        }else{
            [self showBlankViewNoContent];
        }
    } else if (_cardType == HTPreviewCardTypeIndexRecord) {
        [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *callbackQuestionInfo) {
            questionInfo = callbackQuestionInfo;
        }];
        
        _recordView = [[HTRecordView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_recordView];
        [self showAlert];
    } else if (_cardType == HTPreviewCardTypeTimeLevel){
        _timeView = [[HTCardTimeView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_timeView];
        [self showAlert];
    } else if (_cardType == HTPreviewCardTypeHistoryLevel) {
        [self showAlert];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView performBatchUpdates:^{}
                                      completion:^(BOOL finished) {
                                          [self backToToday:NO];
                                      }];
    });
}

- (void)loadUnreadArticleFlag {
    [[[HTServiceManager sharedInstance] profileService] getArticlesInPastWithPage:0 count:0 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        NSLog(@"hasread: %ld",[UD integerForKey:@"hasreadArticlesCount"]);
//        [AppDelegateInstance.mainController showFlag:articles.count - [UD integerForKey:@"hasreadArticlesCount"]];
    }];
}

- (void)createUI {
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
    _bgImageView.hidden = (_cardType != HTPreviewCardTypeRecord);
    [self.view addSubview:_bgImageView];
    
    // 2. 卡片流
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.decelerationRate = 0;
    _collectionView.backgroundColor = [UIColor clearColor];
    if (_cardType == HTPreviewCardTypeDefault)
        _collectionView.alwaysBounceHorizontal = YES;
    else if (_cardType == HTPreviewCardTypeRecord)
        _collectionView.alwaysBounceHorizontal = NO;
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView registerClass:[HTCardCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([HTCardCollectionCell class])];
    [self.view addSubview:_collectionView];
    //    [self.collectionView addSubview:_eggImageView];
    
    // 3. 左上角章节
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
    
    // 4.关闭按钮
    if (_cardType == HTPreviewCardTypeRecord || _cardType == HTPreviewCardTypeIndexRecord || _cardType == HTPreviewCardTypeHistoryLevel || _cardType == HTPreviewCardTypeTimeLevel) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
        [_closeButton sizeToFit];
        [_closeButton addTarget:self action:@selector(onClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    
    // 5.左上灯泡
    _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help"] forState:UIControlStateNormal];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help_highlight"] forState:UIControlStateHighlighted];
    
    [_helpButton addTarget:self action:@selector(arQuestionHelpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_helpButton sizeToFit];
    _helpButton.top = 10;
    _helpButton.left = 10;
    [self.view addSubview:_helpButton];
}

- (void)arQuestionHelpButtonClick:(UIButton *)sender {
    SKHelperScrollView *helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeAR];
    [self.view addSubview:helpView];
    
    helpView.frame = CGRectZero;
    helpView.alpha = 0;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helpView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        helpView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)backToToday {
    [self backToToday:YES];
}

- (void)backToToday:(BOOL)animated {
    [_collectionView setContentOffset:CGPointMake([self contentOffsetWithIndex:questionList.count - 1], 0) animated:animated];
    [self willAppearQuestionAtIndex:questionList.count - 1];
}

- (void)showBlankViewNoContent {
    [_bgImageView removeFromSuperview];
    [_chapterLabel removeFromSuperview];
    [_chapterImageView removeFromSuperview];
    
    _blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
    _blankView.center = self.view.center;
    [_blankView setImage:[UIImage imageNamed:@"img_blank_grey_big"] andOffset:11];
    [self.view addSubview:_blankView];

}

- (void)showBlankViewNetWorkError {
    _blankBackView = [[UIView alloc] initWithFrame:self.view.frame];
    _blankBackView.backgroundColor = [UIColor blackColor];
    [KEY_WINDOW  addSubview:_blankBackView];
    
    _blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
    _blankView.center = self.view.center;
    [_blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:11];
    [_blankBackView addSubview:_blankView];
}

- (void)removeBlankView {
    _blankView = nil;
    [_blankView removeFromSuperview];
    _blankBackView = nil;
    [_blankBackView removeFromSuperview];
}

- (void)onClickCloseButton {
    if ([self.delegate respondsToSelector:@selector(didClickCloseButtonInController:)]) {
        [self.delegate didClickCloseButtonInController:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    CGFloat width = SCREEN_WIDTH - 34;
    return CGSizeMake(width, SCREEN_HEIGHT - ROUND_HEIGHT_FLOAT(96));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kItemMargin;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(ROUND_HEIGHT_FLOAT(96), kItemMargin, 0, kItemMargin);
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
        case HTCardCollectionClickTypeRank: {
            [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
            _showRankView = [[SKRankInQuestionViewController alloc] init];
            _showRankView.questionID = cell.question.questionID;
            if (IOS_VERSION >= 8.0) {
                _showRankView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_showRankView animated:YES completion:nil];
            break;
        }
        case HTCardCollectionClickTypeAnswer: {
            [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
            _showAnswerDetailView = [[SKAnswerDetailView alloc] initWithFrame:self.view.bounds questionID:cell.question.questionID];
            [self.view addSubview:_showAnswerDetailView];
            _showAnswerDetailView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                _showAnswerDetailView.alpha = 1.0f;
            } completion:^(BOOL finished) {
//                [AppDelegateInstance.mainController showBottomButton:NO];
                [self.view bringSubviewToFront:_showAnswerDetailView];
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
            [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
            HTRewardController *reward = [[HTRewardController alloc] initWithRewardID:cell.question.rewardID questionID:cell.question.questionID];
            reward.view.backgroundColor = [UIColor clearColor];
            if (IOS_VERSION >= 8.0) {
                reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:reward animated:YES completion:nil];
            break;
        }
        case HTCardCollectionClickTypeAR: {
            [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
            //判断GPS是否开启
            if ([CLLocationManager locationServicesEnabled]) {
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
                    || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                    //判断相机是否开启
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                    {
                        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
                        [alertView show];
                    } else {
                        HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] initWithQuestion:cell.question];
                        arCaptureController.delegate = self;
                        [self presentViewController:arCaptureController animated:YES completion:nil];
                    }

                }else {
                    HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
                    [alertView show];
                }
            }else {
                HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
                [alertView show];
            }
            break;
        }
        case HTCardCollectionClickTypePause: {
            break;
        }
        case HTCardCollectionClickTypeCompose: {
            _composeView = [[HTComposeView alloc] initWithQustionID:cell.question.questionID frame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _composeView.associatedQuestion = cell.question;
            _composeView.delegate = self;
            _composeView.alpha = 0.0;
            [self.view addSubview:_composeView];
            [_composeView becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                _composeView.alpha = 1.0;
                [self.view addSubview:_composeView];
            } completion:^(BOOL finished) {
                [cell stop];
            }];
            break;
        }
        case HTCardCollectionClickTypeContent: {
            _descriptionView = [[HTDescriptionView alloc] initWithURLString:cell.question.questionDescription andType:HTDescriptionTypeQuestion andImageUrl:cell.question.descriptionURL];
            [self.view addSubview:_descriptionView];
            [_descriptionView showAnimated];
            break;
        }
        case HTCardCollectionClickTypePlay: {
            for (HTCardCollectionCell *iter in _collectionView.visibleCells) {
                if (cell.question.questionID != iter.question.questionID) {
                    [iter stop];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - HTComposeView Delegate

- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
    _composeView.participatorView.hidden = YES;
    if (composeView.associatedQuestion.questionID == [[HTServiceManager sharedInstance] questionService].questionInfo.questionID) {
        [self composeWithAnswer:answer question:composeView.associatedQuestion];
    } else {
        [self composeHistoryQuestionWithAnswer:answer question:composeView.associatedQuestion];
    }
}

- (void)composeHistoryQuestionWithAnswer:(NSString *)answer question:(HTQuestion *)question {
    static int clickCount = 0;
    _composeView.composeButton.enabled = NO;
    [[[HTServiceManager sharedInstance] questionService] verifyHistoryQuestion:question.questionID withAnswer:answer callback:^(BOOL success, HTResponsePackage *response) {
        _composeView.composeButton.enabled = YES;
        if (success) {
            if (response.resultCode == 0) {
                [[[HTServiceManager sharedInstance] profileService] updateProfileInfoFromServer];
                [_composeView showAnswerCorrect:YES];
                clickCount = 0;
                [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *qL) {
                    questionList = [qL mutableCopy];
                    [self willAppearQuestionAtIndex:questionList.count - 1];
                    [self.collectionView reloadData];
                    //                    questionList = [[[[HTServiceManager sharedInstance] questionService] questionList] mutableCopy];
                }];
                // 获取成功了，开始分刮奖励
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_composeView endEditing:YES];
                    [_composeView removeFromSuperview];
                    NSNumber *rewardid = response.data[@"reward_id"];
                    HTRewardController *reward = [[HTRewardController alloc] initWithRewardID:[rewardid integerValue] questionID:question.questionID];
                    reward.view.backgroundColor = [UIColor clearColor];
                    if (IOS_VERSION >= 8.0) {
                        reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    }
                    [self presentViewController:reward animated:YES completion:nil];
                    //                    [[HTUIHelper mainController] reloadMascotViewData];
                });
            } else {
                if (clickCount >= 3) [_composeView showAnswerTips:[NSString stringWithFormat:@"提示:%@", [questionList lastObject].hint]];
                [_composeView showAnswerCorrect:NO];
                clickCount++;
            }
        } else {
            if (clickCount >= 3) [_composeView showAnswerTips:[NSString stringWithFormat:@"提示:%@", [questionList lastObject].hint]];
            [_composeView showAnswerCorrect:NO];
            clickCount++;
        }
    }];
}

- (void)composeWithAnswer:(NSString *)answer question:(HTQuestion *)question {
    static int clickCount = 0;
    _composeView.composeButton.enabled = NO;
    [[[HTServiceManager sharedInstance] questionService] verifyQuestion:question.questionID withAnswer:answer callback:^(BOOL success, HTResponsePackage *response) {
        _composeView.composeButton.enabled = YES;
        if (success) {
            if (response.resultCode == 0) {
                [[[HTServiceManager sharedInstance] profileService] updateProfileInfoFromServer];
                [_composeView showAnswerCorrect:YES];
                clickCount = 0;
                [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *qL) {
                    questionList = [qL mutableCopy];
                    [self willAppearQuestionAtIndex:questionList.count - 1];
                    [self.collectionView reloadData];
//                    questionList = [[[[HTServiceManager sharedInstance] questionService] questionList] mutableCopy];
                }];
                // 获取成功了，开始分刮奖励
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_composeView endEditing:YES];
                    [_composeView removeFromSuperview];
                    NSNumber *rewardid = response.data[@"reward_id"];
                    HTRewardController *reward = [[HTRewardController alloc] initWithRewardID:[rewardid integerValue] questionID:question.questionID];
                    reward.view.backgroundColor = [UIColor clearColor];
                    if (IOS_VERSION >= 8.0) {
                        reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    }
                    [self presentViewController:reward animated:YES completion:nil];
//                    [[HTUIHelper mainController] reloadMascotViewData];
                });
            } else {
                if (clickCount >= 3) [_composeView showAnswerTips:[NSString stringWithFormat:@"提示:%@", [questionList lastObject].hint]];
                [_composeView showAnswerCorrect:NO];
                clickCount++;
            }
        } else {
            if (clickCount >= 3) [_composeView showAnswerTips:[NSString stringWithFormat:@"提示:%@", [questionList lastObject].hint]];
            [_composeView showAnswerCorrect:NO];
            clickCount++;
        }
    }];
}

- (void)didClickDimingViewInComposeView:(HTComposeView *)composeView {
    [self.view endEditing:YES];
    [composeView removeFromSuperview];
}

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller {
    [controller dismissViewControllerAnimated:NO completion:^{
        questionList = [[[[HTServiceManager sharedInstance] questionService] questionList] mutableCopy];
        [self willAppearQuestionAtIndex:questionList.count - 1];
        [self.collectionView reloadData];
        HTRewardController *reward = [[HTRewardController alloc] initWithRewardID:controller.rewardID questionID:controller.question.questionID];
        reward.view.backgroundColor = [UIColor clearColor];
        if (IOS_VERSION >= 8.0) {
            reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:reward animated:YES completion:nil];
//        [[HTUIHelper mainController] reloadMascotViewData];
    }];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = [self indexWithContentOffsetX:scrollView.contentOffset.x];
    if (self.cardType == HTPreviewCardTypeDefault && questionList.count > 3) {
        if (currentIndex <= questionList.count - 4) {
//            [[HTUIHelper mainController] showBackToToday:YES];
        }
        if (currentIndex >= questionList.count - 3) {
//            [[HTUIHelper mainController] showBackToToday:NO];
        }
    }
    static CGFloat preContentOffsetX = 0.0;
    if (_cardType == HTPreviewCardTypeDefault) {
        if (scrollView.contentOffset.x + SCREEN_WIDTH >= _eggImageView.right && preContentOffsetX != 0) {
            [scrollView setContentOffset:CGPointMake(_eggImageView.right - SCREEN_WIDTH, scrollView.contentOffset.y)];
            if (!_eggCoverImageView.superview) {
                _eggCoverImageView.frame = SCREEN_BOUNDS;
                _eggCoverImageView.left = SCREEN_WIDTH;
                _eggCoverImageView.userInteractionEnabled = YES;
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
                [_eggCoverImageView addGestureRecognizer:panGesture];
                
                [KEY_WINDOW addSubview:_eggCoverImageView];
                [self bounceEaseOut];
                //            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //                _eggCoverImageView.left = 0;
                //            } completion:^(BOOL finished) {
                //                [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
                //            }];
            }
        }
    }
    _scrollDirection = (scrollView.contentOffset.x > preContentOffsetX) ? HTScrollDirectionLeft : HTScrollDirectionRight;
    preContentOffsetX = scrollView.contentOffset.x;
}

- (void)bounceEaseOut {
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animation];
    keyFrameAnimation.keyPath = @"position";
    keyFrameAnimation.duration = 0.8f;
    keyFrameAnimation.values = [YXEasing calculateFrameFromPoint:_eggCoverImageView.center
                                                         toPoint:CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.)
                                                            func:BounceEaseOut
                                                      frameCount:2 * 30];
    _eggCoverImageView.center = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    [_eggCoverImageView.layer addAnimation:keyFrameAnimation forKey:nil];
    [self.collectionView.visibleCells makeObjectsPerformSelector:@selector(stop)];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    if (translation.x <= 0) return;
    
    _eggCoverImageView.centerX = SCREEN_WIDTH / 2 + translation.x;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (translation.x >= 50) {
            [UIView animateWithDuration:0.3 animations:^{
                _eggCoverImageView.left = SCREEN_WIDTH;
            } completion:^(BOOL finished) {
                [_eggCoverImageView removeFromSuperview];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                _eggCoverImageView.left = 0;
            } completion:^(BOOL finished) {
            }];
        }
    }
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

#pragma mark - Remote Notification

- (BOOL)isAllowedNotification
{
    if
        ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {// system is iOS8 +
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if
                (UIUserNotificationTypeNone != setting.types) {
                    return YES;
                }
        }
    else
    {// iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

#pragma mark - Action

- (void)willAppearQuestionAtIndex:(NSInteger)index {
    if (index < 0 || index > questionList.count) return;
    if (questionList.count == 0) return;
    _chapterLabel.text = [NSString stringWithFormat:@"%02lu", (unsigned long)questionList[index].serial];
    [_timeView setQuestion:questionList[index] andQuestionInfo:questionInfo];
    [_recordView setQuestion:questionList[index]];
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

#pragma mark - ShowCourseView

- (void)showGuideview {
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.frame];
    blackView.backgroundColor = [UIColor blackColor];
    
    _guideView = [[SKHelperGuideView alloc] initWithFrame:self.view.frame withType:SKHelperGuideViewType1];
    _guideView.alpha = 0;
    
    [KEY_WINDOW addSubview:blackView];
    [KEY_WINDOW bringSubviewToFront:blackView];
    [KEY_WINDOW addSubview:_guideView];
    [KEY_WINDOW bringSubviewToFront:_guideView];
    
    [UIView animateWithDuration:1.2 animations:^{
        blackView.alpha = 0;
        _guideView.alpha = 1;
    } completion:^(BOOL finished) {
        _currentCourseImageIndex = 1;
    }];
}

- (void)showCourseView {
    UIView *blackView = [[UIView alloc] initWithFrame:self.view.frame];
    blackView.backgroundColor = [UIColor blackColor];
    
    _courseView = [[UIView alloc] initWithFrame:self.view.frame];
    _courseView.alpha = 0;
    
    [KEY_WINDOW addSubview:blackView];
    [KEY_WINDOW bringSubviewToFront:blackView];
    [KEY_WINDOW addSubview:_courseView];
    [KEY_WINDOW bringSubviewToFront:_courseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickCourseImage)];
    [_courseView addGestureRecognizer:tap];
    
    //step.1
    UIView *view1 = [UIView new];
    [_courseView addSubview:view1];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:_courseView.frame];
    [view1 addSubview:imageView1];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_guide_know"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"btn_guide_know_highlight"] forState:UIControlStateHighlighted];
    [view1 addSubview:button1];
    
    
    
    _courseImageArray = [NSMutableArray new];
    _currentCourseImageIndex = 0;
    if (SCREEN_WIDTH<=IPHONE5_SCREEN_WIDTH || SCREEN_WIDTH>=IPHONE6_PLUS_SCREEN_WIDTH) {
        for (int i=1; i<=4; i++) {
            [_courseImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"coach_mark_%d",i]]];
        }
    } else {
        for (int i=1; i<=4; i++) {
            [_courseImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"coach_mark_iphone6_%d",i]]];
        }
    }
    
    _courseImageView = [[UIImageView alloc] initWithFrame:_courseView.frame];
    _courseImageView.image = _courseImageArray[_currentCourseImageIndex];
    [_courseView addSubview:_courseImageView];
    
    [UIView animateWithDuration:1.2 animations:^{
        blackView.alpha = 0;
        _courseView.alpha = 1;
    } completion:^(BOOL finished) {
        _currentCourseImageIndex = 1;
    }];
}

- (void)onClickCourseImage {
    if (_currentCourseImageIndex == 5) {
        [UIView animateWithDuration:0.3 animations:^{
            _courseView.alpha = 0;
        } completion:^(BOOL finished) {
            [_courseView removeFromSuperview];
            [self showAlert];
        }];
    } else if (_currentCourseImageIndex<=4) {
        _courseImageView.image = _courseImageArray[_currentCourseImageIndex];
        _currentCourseImageIndex++;
    }
}

#pragma mark - GPS Alert

- (void)showAlert {
    //通知Alert
    if (![UD boolForKey:@"hasShowPushAlert"]&&![self isAllowedNotification]) {
        if (!FIRST_LAUNCH){
            //未显示过
            HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypePush];
            [alertView show];
            [UD setBool:YES forKey:@"hasShowPushAlert"];
        }
    }
    
    //地理位置Alert
    //判断GPS是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DLog(@"authorizationStatus -> %d", [CLLocationManager authorizationStatus]);
        }else {
            HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
            [alertView show];
        }
    }else {
        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
        [alertView show];
    }
}

@end
