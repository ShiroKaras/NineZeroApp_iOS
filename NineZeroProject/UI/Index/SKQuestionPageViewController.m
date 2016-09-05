//
//  SKQuestionPageViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/2.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionPageViewController.h"
#import "HTUIHeader.h"

@interface SKQuestionPageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create UI
- (void)createUI {
    self.view.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    __weak __typeof(self)weakSelf = self;
    
    float collectionHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90));
    collectionLayout.minimumLineSpacing = ROUND_WIDTH_FLOAT(0);
    collectionLayout.minimumInteritemSpacing = ROUND_HEIGHT_FLOAT(0);
//    collectionLayout.sectionInset = UIEdgeInsetsMake(ROUND_WIDTH_FLOAT(13), ROUND_WIDTH_FLOAT(14.5), ROUND_WIDTH_FLOAT(13), ROUND_WIDTH_FLOAT(14.5));
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(20.5), 60-13, SCREEN_WIDTH-ROUND_WIDTH_FLOAT(41), collectionHeight) collectionViewLayout:collectionLayout];
    mCollectionView.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    mCollectionView.pagingEnabled = YES;
    mCollectionView.showsVerticalScrollIndicator = NO;
    mCollectionView.showsHorizontalScrollIndicator = NO;
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    [mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ReuseCell"];
    [self.view addSubview:mCollectionView];
    
    _pageContrl = [[UIPageControl alloc] init];
    _pageContrl.numberOfPages = 8;
    _pageContrl.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _pageContrl.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _pageContrl.userInteractionEnabled = NO;
    [self.view addSubview:_pageContrl];

    [_pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(mCollectionView.mas_bottom).offset(42);
        make.height.equalTo(@(8));
    }];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"btn_levelpage_uncompleted"];
    imageView.frame = CGRectMake((cell.width-64)/2,(cell.height-64)/2, 64, 64);
//    NSLog(@"Index %ld", indexPath.row);
    [cell addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 90;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //得到图片移动相对原点的坐标
    CGPoint point=scrollView.contentOffset;
    //移动不能超过左边;
    if(point.x<0){
        point.x=0;
        scrollView.contentOffset=point;
    }
    //移动不能超过右边
    if(point.x>7*(SCREEN_WIDTH-ROUND_WIDTH_FLOAT(41))){
        point.x=(SCREEN_WIDTH-ROUND_WIDTH_FLOAT(41))*7;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    NSInteger index=round(point.x/(SCREEN_WIDTH-ROUND_WIDTH_FLOAT(41)));
    _pageContrl.currentPage=index;
}

@end
