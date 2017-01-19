//
//  SKAllQuestionViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKAllQuestionViewController.h"
#import "SKHelperView.h"
#import "SKQuestionViewController.h"

#define PAGE_COUNT_SEASON1 (ceil(self.questionList_season1.count/12.))
#define PAGE_COUNT_SEASON2 (ceil(90./12.))

@interface SKAllQuestionViewController ()<UIScrollViewDelegate, SKHelperScrollViewDelegate, SKQuestionViewControllerDelegate>

@property(nonatomic, strong) UIScrollView   *mScrollView_season1;
@property(nonatomic, strong) UIPageControl  *mPageContrl_season1;
@property(nonatomic, strong) UIScrollView   *mScrollView_season2;
@property(nonatomic, strong) UIPageControl  *mPageContrl_season2;
@property(nonatomic, strong) UIView         *tempView;

@property(nonatomic, strong) UIButton       *helpButton;
@property(nonatomic, strong) UIImageView    *mascotImageView;
@property(nonatomic, strong) UIButton       *season1Button;
@property(nonatomic, strong) UIButton       *season2Button;

@property(nonatomic, assign) NSInteger season;

@property (nonatomic, strong) UIView *HUDView;
@property (nonatomic, strong) UIImageView *HUDImageView;
@end

@implementation SKAllQuestionViewController{
    UICollectionView *mCollectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"alllevelspage"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"alllevelspage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addObserver:self forKeyPath:@"season" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"season"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Load data
- (void)loadData {
    [[[SKServiceManager sharedInstance] questionService] getAllQuestionListCallback:^(BOOL success, NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2) {
        NSMutableArray *mQuestionList_season1 = [questionList_season1 mutableCopy];
        [self createSeason1UIWithData:mQuestionList_season1];
        
        NSMutableArray *mQuestionList_season2 = [questionList_season2 mutableCopy];
        [self createSeason2UIWithData:mQuestionList_season2];
        
        if (answeredQuestion_season1 < 60)  self.season = 1;
        else                                self.season = 2;
        
        if (FIRST_LAUNCH_QUESTIONLIST) {
            [self helpButtonClick:nil];
            [UD setBool:YES forKey:@"firstLaunchQuestionList"];
        }
        
        [self hideHUD];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [HTProgressHUD dismiss];
//        });
    }];
}

#pragma mark - Create UI
- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    WS(weakSelf);
    
    _helpButton = [UIButton new];
    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateHighlighted];
    [_helpButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_helpButton];
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.view).offset(12);
        make.right.equalTo(weakSelf.view).offset(-4);
    }];
    
    _mascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_levelpage_season1"]];
    [self.view addSubview:_mascotImageView];
    [_mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    _season1Button = [UIButton new];
    [_season1Button addTarget:self action:@selector(season1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_season1Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season1_highlight"] forState:UIControlStateNormal];
    [_season1Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season1_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_season1Button];
    [_season1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mascotImageView);
        make.bottom.equalTo(_mascotImageView.mas_top);
    }];
    
    _season2Button = [UIButton new];
    [_season2Button addTarget:self action:@selector(season2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_season2Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season2"] forState:UIControlStateNormal];
    [_season2Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season2_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_season2Button];
    [_season2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mascotImageView);
        make.bottom.equalTo(_mascotImageView.mas_top);
    }];

    [self createTempView];
    
    _HUDView = [[UIView alloc] initWithFrame:self.view.frame];
    _HUDView.backgroundColor = [UIColor blackColor];
    NSInteger count = 40;
    NSMutableArray *images = [NSMutableArray array];
    CGFloat length = 156;
    _HUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - length / 2, SCREEN_HEIGHT / 2 - length / 2, length, length)];
    _HUDImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_0000"]];
    for (int i = 0; i != count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_00%02d", i]];
        [images addObject:image];
    }
    _HUDImageView.animationImages = images;
    _HUDImageView.animationDuration = 2.0;
    _HUDImageView.animationRepeatCount = 0;
    [_HUDView addSubview:_HUDImageView];
    
    [self showHUD];

    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:blankView];
        blankView.top = ROUND_HEIGHT_FLOAT(217);
        [self hideHUD];
    } else {
        [self loadData];
    }
}

- (void)createTempView {
    float scrollViewHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, scrollViewHeight)];
    [self.view addSubview:_tempView];
    
    for (int questionNumber=0; questionNumber<12; questionNumber++) {
        int pageNumber = floor(questionNumber/12);
        int itemInPage = questionNumber-pageNumber*12;
        int i = itemInPage%3;
        int j = floor(itemInPage/3);
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(35)+SCREEN_WIDTH*pageNumber+i*ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90)*j, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        coverImageView.image = [UIImage imageNamed:@"img_profile_photo_default"];
        coverImageView.layer.cornerRadius = itemView.width/2;
        coverImageView.layer.masksToBounds = YES;
        [itemView addSubview:coverImageView];
        
        UIImageView *mImageButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_levelpage_uncompleted"]];
        mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
        [itemView addSubview:mImageButton];
        
        //关卡号
        UILabel *mQuestionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        mQuestionNumberLabel.textColor = [UIColor whiteColor];
        mQuestionNumberLabel.text = [NSString stringWithFormat:@"%d",questionNumber+1];
        mQuestionNumberLabel.textAlignment = NSTextAlignmentCenter;
        mQuestionNumberLabel.font = MOON_FONT_OF_SIZE(23);
        [itemView addSubview:mQuestionNumberLabel];
        
        [_tempView addSubview:itemView];
    }
}

- (void)createSeason1UIWithData:(NSArray<SKQuestion*>*)questionList {
    self.questionList_season1 = questionList;
    
    float scrollViewHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    _mScrollView_season1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, scrollViewHeight)];
    _mScrollView_season1.backgroundColor = COMMON_BG_COLOR;
    _mScrollView_season1.delegate = self;
    _mScrollView_season1.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT_SEASON1, scrollViewHeight);
    _mScrollView_season1.pagingEnabled = YES;
    _mScrollView_season1.showsHorizontalScrollIndicator = NO;
    _mScrollView_season1.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView_season1];
    
    _mPageContrl_season1 = [[UIPageControl alloc] init];
    _mPageContrl_season1.numberOfPages = PAGE_COUNT_SEASON1;
    _mPageContrl_season1.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _mPageContrl_season1.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _mPageContrl_season1.userInteractionEnabled = NO;
    [self.view addSubview:_mPageContrl_season1];
    [_mPageContrl_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_mScrollView_season1.mas_bottom).offset(2);
        make.height.equalTo(@(8));
    }];
    
    _mScrollView_season1.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT_SEASON1, (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4));
    _mPageContrl_season1.numberOfPages = PAGE_COUNT_SEASON1;
    
    for (UIView *view in self.mScrollView_season1.subviews) {
        [view removeFromSuperview];
    }
    
    for (int questionNumber=0; questionNumber<questionList.count; questionNumber++) {
        int pageNumber = floor(questionNumber/12);
        int itemInPage = questionNumber-pageNumber*12;
        int i = itemInPage%3;
        int j = floor(itemInPage/3);
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(35)+SCREEN_WIDTH*pageNumber+i*ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90)*j, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        coverImageView.tag = 300+questionNumber;
        NSURL *coverURL = ([questionList[questionNumber].thumbnail_pic isEqualToString:@""]||questionList[questionNumber].thumbnail_pic==nil)?[NSURL URLWithString:questionList[questionNumber].question_video_cover]: [NSURL URLWithString:questionList[questionNumber].thumbnail_pic];
        if (coverURL == nil) {
            coverImageView.image = [UIImage imageNamed:@"img_profile_photo_default"];
        } else {
            [coverImageView sd_setImageWithURL:coverURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                int type;
                if (questionList[questionNumber].is_answer || !(questionList[questionNumber].base_type == 0))  type = 0;
                else    type = 1;
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    
                    NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                    BOOL result = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
                    NSString* imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
                    NSData* newData = [NSData dataWithContentsOfFile:imagePath];
                    if (!result || !newData) {
                        BOOL imageIsPng = [[self typeForImageData:newData] isEqualToString:@"image/png"];
                        NSData* imageData = nil;
                        if (imageIsPng) {
                            imageData = UIImagePNGRepresentation(image);
                        }
                        else {
                            imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                        }
                        NSFileManager* _fileManager = [NSFileManager defaultManager];
                        if (imageData) {
                            [_fileManager removeItemAtPath:imagePath error:nil];
                            [_fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                        }
                    }
                    newData = [NSData dataWithContentsOfFile:imagePath];
                    UIImage* grayImage = nil;
                    if (type == 0) {
                        grayImage = [UIImage imageWithData:newData];
                    }else{
                        UIImage* newImage = [UIImage imageWithData:newData];
                        grayImage = [self grayscale:newImage type:1];
                    }
                    coverImageView.image = grayImage;
                }];
            }];
        }
        coverImageView.layer.cornerRadius = itemView.width/2;
        coverImageView.layer.masksToBounds = YES;
        [itemView addSubview:coverImageView];
        
        //按钮
        UIButton *mImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mImageButton.tag = 100+questionNumber;
        [mImageButton addTarget:self action:@selector(questionSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
        mImageButton.titleLabel.font = MOON_FONT_OF_SIZE(23);
        [mImageButton setTitle:[NSString stringWithFormat:@"%d",questionNumber+1] forState:UIControlStateNormal];
        [mImageButton setTitleColor:[UIColor colorWithHex:0x00DFB4] forState:UIControlStateHighlighted];
        if (questionList[questionNumber].is_answer) {
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
            
            [mImageButton setTitleColor:COMMON_PINK_COLOR forState:UIControlStateNormal];
        } else {
            [mImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (questionList[questionNumber].base_type == 1 || questionList[questionNumber].base_type == 2) {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR_highlight"] forState:UIControlStateHighlighted];
            } else {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted_highlight"] forState:UIControlStateHighlighted];
            }
        }
        [itemView addSubview:mImageButton];
        
        [_mScrollView_season1 addSubview:itemView];
    }
}

- (void)createSeason2UIWithData:(NSArray<SKQuestion*>*)questionList {
    self.questionList_season2 = questionList;
    
    float scrollViewHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    _mScrollView_season2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, scrollViewHeight)];
    _mScrollView_season2.backgroundColor = COMMON_BG_COLOR;
    _mScrollView_season2.delegate = self;
    _mScrollView_season2.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT_SEASON2, scrollViewHeight);
    _mScrollView_season2.pagingEnabled = YES;
    _mScrollView_season2.showsHorizontalScrollIndicator = NO;
    _mScrollView_season2.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView_season2];
    
    _mPageContrl_season2 = [[UIPageControl alloc] init];
    _mPageContrl_season2.numberOfPages = PAGE_COUNT_SEASON2;
    _mPageContrl_season2.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _mPageContrl_season2.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _mPageContrl_season2.userInteractionEnabled = NO;
    [self.view addSubview:_mPageContrl_season2];
    [_mPageContrl_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_mScrollView_season2.mas_bottom).offset(2);
        make.height.equalTo(@(8));
    }];
    
    _mScrollView_season2.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT_SEASON2, (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4));
    _mPageContrl_season2.numberOfPages = PAGE_COUNT_SEASON2;
    
    for (UIView *view in self.mScrollView_season2.subviews) {
        [view removeFromSuperview];
    }
    
    for (int questionNumber=0; questionNumber<90; questionNumber++) {
        int pageNumber = floor(questionNumber/12);
        int itemInPage = questionNumber-pageNumber*12;
        int i = itemInPage%3;
        int j = floor(itemInPage/3);
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(35)+SCREEN_WIDTH*pageNumber+i*ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90)*j, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        coverImageView.tag = 400+questionNumber;
        coverImageView.layer.cornerRadius = itemView.width/2;
        coverImageView.layer.masksToBounds = YES;
        [itemView addSubview:coverImageView];
        
        if (questionNumber<questionList.count) {
            NSURL *coverURL = ([questionList[questionNumber].thumbnail_pic isEqualToString:@""]||questionList[questionNumber].thumbnail_pic==nil)?[NSURL URLWithString:questionList[questionNumber].question_video_cover]: [NSURL URLWithString:questionList[questionNumber].thumbnail_pic];
            if (coverURL == nil) {
                coverImageView.image = [UIImage imageNamed:@"img_profile_photo_default"];
            } else {
                [coverImageView sd_setImageWithURL:coverURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    int type;
                    if (questionList[questionNumber].is_answer || questionList[questionNumber].base_type!=0)  type = 0;
                    else    type = 1;
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                        NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                        BOOL result = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
                        NSString* imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
                        NSData* newData = [NSData dataWithContentsOfFile:imagePath];
                        if (!result || !newData) {
                            BOOL imageIsPng = [[self typeForImageData:newData] isEqualToString:@"image/png"];
                            NSData* imageData = nil;
                            if (imageIsPng) {
                                imageData = UIImagePNGRepresentation(image);
                            }
                            else {
                                imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                            }
                            NSFileManager* _fileManager = [NSFileManager defaultManager];
                            if (imageData) {
                                [_fileManager removeItemAtPath:imagePath error:nil];
                                [_fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                            }
                        }
                        newData = [NSData dataWithContentsOfFile:imagePath];
                        UIImage* grayImage = nil;
                        if (type == 0) {
                            grayImage = [UIImage imageWithData:newData];
                        }else{
                            UIImage* newImage = [UIImage imageWithData:newData];
                            grayImage = [self grayscale:newImage type:1];
                        }
                        coverImageView.image = grayImage;
                    }];
                }];
            }
            
            //按钮
            UIButton *mImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            mImageButton.tag = 100+questionNumber;
            [mImageButton addTarget:self action:@selector(questionSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
            mImageButton.titleLabel.font = MOON_FONT_OF_SIZE(23);
            [mImageButton setTitle:[NSString stringWithFormat:@"%d",questionNumber+1] forState:UIControlStateNormal];
            [mImageButton setTitleColor:[UIColor colorWithHex:0x00DFB4] forState:UIControlStateHighlighted];
            if (questionList[questionNumber].is_answer) {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
                [mImageButton setTitleColor:COMMON_PINK_COLOR forState:UIControlStateNormal];
            } else {
                //是否是限时关卡
                if (questionNumber == questionList.count-1 && !_isMonday) {
                    [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_timer"] forState:UIControlStateNormal];
                    [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_timer_highlight"] forState:UIControlStateHighlighted];
                } else {
                    if (questionList[questionNumber].base_type == 1 || questionList[questionNumber].base_type == 2) {
                        [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR"] forState:UIControlStateNormal];
                        [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR_highlight"] forState:UIControlStateHighlighted];
                    } else {
                        [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted"] forState:UIControlStateNormal];
                        [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted_highlight"] forState:UIControlStateHighlighted];
                    }
                }
            }
            [itemView addSubview:mImageButton];
        } else {
            //按钮
            UIButton *mImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            mImageButton.tag = questionNumber;
            mImageButton.adjustsImageWhenHighlighted = NO;
            [mImageButton addTarget:self action:@selector(lockedQuestionSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_locked"] forState:UIControlStateNormal];
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_locked_highlight"] forState:UIControlStateHighlighted];
            [itemView addSubview:mImageButton];
        }
        
        
        [_mScrollView_season2 addSubview:itemView];
    }
}

- (void)updateUIWithData:(NSArray<SKQuestion*>*)questionList {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mScrollView_season1) {
        //得到图片移动相对原点的坐标
        CGPoint point=scrollView.contentOffset;
        //移动不能超过左边;
        //    if(point.x<0){
        //        point.x=0;
        //        scrollView.contentOffset=point;
        //    }
        //移动不能超过右边
        if(point.x>PAGE_COUNT_SEASON1*(SCREEN_WIDTH)) {
            point.x=(SCREEN_WIDTH)*PAGE_COUNT_SEASON1;
            scrollView.contentOffset=point;
        }
        //根据图片坐标判断页数
        NSInteger index=round(point.x/(SCREEN_WIDTH));
        _mPageContrl_season1.currentPage=index;
    } else if (scrollView == _mScrollView_season2) {
        //得到图片移动相对原点的坐标
        CGPoint point=scrollView.contentOffset;
        //移动不能超过右边
        if(point.x>PAGE_COUNT_SEASON2*(SCREEN_WIDTH)) {
            point.x=(SCREEN_WIDTH)*PAGE_COUNT_SEASON2;
            scrollView.contentOffset=point;
        }
        //根据图片坐标判断页数
        NSInteger index=round(point.x/(SCREEN_WIDTH));
        _mPageContrl_season2.currentPage=index;
    }
}

#pragma mark - Actions

//- (void)closeButtonClick:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//点击活动关卡
- (void)questionSelectButtonClick:(UIButton *)sender {
    NSLog(@"%ld", sender.tag);
    NSString *questionID;
    if (self.season == 1) {
        questionID = self.questionList_season1[sender.tag-100].qid;
    } else if (self.season == 2){
        questionID = self.questionList_season2[sender.tag-200].qid;
    }
    
    if (questionID == [self.questionList_season2 lastObject].qid && self.isMonday == NO) {
        SKQuestionViewController *controller = [[SKQuestionViewController alloc] initWithType:SKQuestionTypeTimeLimitLevel questionID:questionID endTime:self.indexInfo.question_end_time];
        self.season = self.season;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        SKQuestionViewController *controller = [[SKQuestionViewController alloc] initWithType:SKQuestionTypeHistoryLevel questionID:questionID];
        controller.season = self.season;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//点击锁定关卡
- (void)lockedQuestionSelectButtonClick:(UIButton *)sender {
    [self showPromptWithText:@"关卡即将开启，敬请期待"];
}

- (void)showPromptWithText:(NSString*)text {
    [[self.view viewWithTag:9002] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_levelpage_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 9002;
    promptView.size = promptImageView.size;
    promptView.center = self.view.center;
    promptView.alpha = 0;
    [self.view addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.frame = CGRectMake(8.5, 11, promptView.width-17, 57);
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

- (void)helpButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"backgroundtips"];
    SKHelperScrollView *helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeQuestion];
    helpView.delegate = self;
    helpView.scrollView.frame = CGRectMake(SCREEN_WIDTH, -(SCREEN_HEIGHT-356)/2, 0, 0);
    helpView.dimmingView.alpha = 0;
    [self.view addSubview:helpView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        helpView.dimmingView.alpha = 0.9;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)season1ButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"seasonone"];
    self.season = 1;
}

- (void)season2ButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"seasontwo"];
    self.season = 2;
}

- (void)showHUD {
    [AppDelegateInstance.window addSubview:_HUDView];
    _HUDView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _HUDView.alpha = 1;
        [_HUDImageView startAnimating];
    }];
}

- (void)hideHUD {
    [_HUDView removeFromSuperview];
}

#pragma mark - SKHelperScrollViewDelegate

- (void)didClickCompleteButton {
    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.075 animations:^{
        _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.075 animations:^{
            _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^{
                _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.075 animations:^{
                    _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                } completion:^(BOOL finished) {
                    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
                }];
            }];
        }];
    }];
}

#pragma mark - HTPreviewCardController

#pragma mark - Tool
- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

#pragma mark - Delegate

- (void)answeredQuestionWithSerialNumber:(NSString *)serial season:(NSInteger)season {
    if (season == 1) {
        self.questionList_season1[[serial integerValue]-1].is_answer = YES;
        [((UIButton*)[self.view viewWithTag:100+[serial integerValue]-1]) setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
        [((UIButton*)[self.view viewWithTag:100+[serial integerValue]-1]) setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
        [((UIButton*)[self.view viewWithTag:100+[serial integerValue]-1]) setTitleColor:COMMON_PINK_COLOR forState:UIControlStateNormal];
        NSURL *coverURL = ([self.questionList_season1[[serial integerValue]-1].thumbnail_pic isEqualToString:@""]||self.questionList_season1[[serial integerValue]-1].thumbnail_pic==nil)?[NSURL URLWithString:self.questionList_season1[[serial integerValue]-1].question_video_cover]: [NSURL URLWithString:self.questionList_season1[[serial integerValue]-1].thumbnail_pic];
        [((UIImageView*)[self.view viewWithTag:300+[serial integerValue]-1]) sd_setImageWithURL:coverURL];
    } else if (season == 2) {
        self.questionList_season2[[serial integerValue]-1].is_answer = YES;
        [((UIButton*)[self.view viewWithTag:200+[serial integerValue]-1]) setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
        [((UIButton*)[self.view viewWithTag:200+[serial integerValue]-1]) setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
        [((UIButton*)[self.view viewWithTag:200+[serial integerValue]-1]) setTitleColor:COMMON_PINK_COLOR forState:UIControlStateNormal];
        NSURL *coverURL = ([self.questionList_season2[[serial integerValue]-1].thumbnail_pic isEqualToString:@""]||self.questionList_season2[[serial integerValue]-1].thumbnail_pic==nil)?[NSURL URLWithString:self.questionList_season2[[serial integerValue]-1].question_video_cover]: [NSURL URLWithString:self.questionList_season2[[serial integerValue]-1].thumbnail_pic];
        [((UIImageView*)[self.view viewWithTag:400+[serial integerValue]-1]) sd_setImageWithURL:coverURL];
    }
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"season"]) {
        NSLog(@"%ld", self.season);
        if (self.season == 1) {
            _mascotImageView.image = [UIImage imageNamed:@"img_levelpage_season1"];
            [_season1Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season1_highlight"] forState:UIControlStateNormal];
            [_season2Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season2"] forState:UIControlStateNormal];

            _mScrollView_season1.hidden = NO;
            _mPageContrl_season1.hidden = NO;
            _mScrollView_season2.hidden = YES;
            _mPageContrl_season2.hidden = YES;
        } else if (self.season == 2) {
            _mascotImageView.image = [UIImage imageNamed:@"img_levelpage_season2"];
            [_season1Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season1"] forState:UIControlStateNormal];
            [_season2Button setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_season2_highlight"] forState:UIControlStateNormal];
            
            _mScrollView_season1.hidden = YES;
            _mPageContrl_season1.hidden = YES;
            _mScrollView_season2.hidden = NO;
            _mPageContrl_season2.hidden = NO;
        }
    }
}


@end
