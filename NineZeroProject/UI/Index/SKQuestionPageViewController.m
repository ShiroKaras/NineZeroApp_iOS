//
//  SKQuestionPageViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/2.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionPageViewController.h"
#import "HTPreviewCardController.h"

#define PAGE_COUNT (floor(self.questionList.count/12)+1)

@interface SKQuestionPageViewController ()<UIScrollViewDelegate, HTPreviewCardControllerDelegate>

@property(nonatomic, strong) UIScrollView *mScrollView;
@property(nonatomic, strong) UIPageControl *pageContrl;

@end

@implementation SKQuestionPageViewController {
    UICollectionView *mCollectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self updateUIWithData:self.questionList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create UI
- (void)createUI {
    self.view.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    
    float scrollViewHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, scrollViewHeight)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT, scrollViewHeight);
    _mScrollView.pagingEnabled = YES;
    [self.view addSubview:_mScrollView];
    
    __weak __typeof(self)weakSelf = self;
    UIButton *cancelButton = [UIButton new];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-26);
    }];
}

- (void)loadData {
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        
    }];
}

- (void)updateUIWithData:(NSArray<HTQuestion*>*)questionList {
    self.questionList = questionList;
    
    for (int questionNumber=0; questionNumber<questionList.count; questionNumber++) {
        int pageNumber = floor(questionNumber/12);
        int itemInPage = questionNumber-pageNumber*12;
        int i = itemInPage%3;
        int j = floor(itemInPage/3);
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(35)+SCREEN_WIDTH*pageNumber+i*ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90)*j, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:questionList[questionNumber].question_video_cover] placeholderImage:nil];
        coverImageView.layer.cornerRadius = itemView.width/2;
        coverImageView.layer.masksToBounds = YES;
        [itemView addSubview:coverImageView];

        //按钮
        UIButton *mImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mImageButton.tag = questionNumber;
        [mImageButton addTarget:self action:@selector(questionSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
        if (questionList[questionNumber].isPassed) {
            if (![questionList[questionNumber].question_ar_location isEqualToString:@""]) {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR_highlight"] forState:UIControlStateHighlighted];
            } else {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
            }
        } else {
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted"] forState:UIControlStateNormal];
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted_highlight"] forState:UIControlStateHighlighted];
        }
        [itemView addSubview:mImageButton];
        
        //关卡号
        UILabel *mQuestionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        mQuestionNumberLabel.textColor = [UIColor whiteColor];
        mQuestionNumberLabel.text = [NSString stringWithFormat:@"%d",questionNumber+1];
        mQuestionNumberLabel.textAlignment = NSTextAlignmentCenter;
        mQuestionNumberLabel.font = MOON_FONT_OF_SIZE(23);
        [itemView addSubview:mQuestionNumberLabel];
        
        [_mScrollView addSubview:itemView];
    }
    
    _pageContrl = [[UIPageControl alloc] init];
    _pageContrl.numberOfPages = PAGE_COUNT;
    _pageContrl.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _pageContrl.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _pageContrl.userInteractionEnabled = NO;
    [self.view addSubview:_pageContrl];

    __weak __typeof(self)weakSelf = self;
    [_pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_mScrollView.mas_bottom).offset(42);
        make.height.equalTo(@(8));
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //得到图片移动相对原点的坐标
    CGPoint point=scrollView.contentOffset;
    //移动不能超过左边;
//    if(point.x<0){
//        point.x=0;
//        scrollView.contentOffset=point;
//    }
    //移动不能超过右边
    if(point.x>PAGE_COUNT*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*PAGE_COUNT;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    NSInteger index=round(point.x/(SCREEN_WIDTH));
    _pageContrl.currentPage=index;
}

#pragma mark - Actions

- (void)cancelButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)questionSelectButtonClick:(UIButton *)sender {
    HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeIndexRecord andQuestList:@[self.questionList[sender.tag]]];
    cardController.delegate = self;
    [self.navigationController pushViewController:cardController animated:YES];
}

#pragma mark - HTPreviewCardController

- (void)didClickCloseButtonInController:(HTPreviewCardController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
