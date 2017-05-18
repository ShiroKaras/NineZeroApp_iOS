//
//  NZTaskDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskDetailViewController.h"
#import "HTUIHeader.h"
#import "NZTaskDetailView.h"

@interface NZTaskDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) SKStrongholdItem *detail;

@property (nonatomic, strong) UIImageView   *titleImageView;
@property (nonatomic, strong) UIView        *tabBackView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *indicatorLine;
@property (nonatomic, strong) UIButton      *button1;
@property (nonatomic, strong) UIButton      *button2;
@property (nonatomic, strong) UIButton      *addTaskButton;
//@property (nonatomic, strong) UIView        *tipsBackView;
@property (nonatomic, assign) BOOL          isAddTaskList;
@end

@implementation NZTaskDetailViewController

- (instancetype)initWithID:(NSString*)sid {
    self = [super init];
    if (self) {
        _detail = [SKStrongholdItem new];
        _detail.id = sid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    _isAddTaskList = NO;
    [[[SKServiceManager sharedInstance] strongholdService] getStrongholdInfoWithID:_detail.id callback:^(BOOL success, SKStrongholdItem *strongholdItem) {
        _detail = strongholdItem;
        
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:strongholdItem.bigpic] placeholderImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        
        NZTaskDetailView *detailView = [[NZTaskDetailView alloc] initWithFrame:CGRectMake(0, _titleImageView.bottom, self.view.width, 1000) withModel:strongholdItem];
        [_scrollView addSubview:detailView];
        
        _scrollView.contentSize = CGSizeMake(self.view.width, detailView.viewHeight+16+40+ROUND_WIDTH_FLOAT(240));
    }];
}

- (void)createUI {
    WS(weakSelf);
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //MainView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width/320*240)];
    _titleImageView.image = [UIImage imageNamed:@"img_monday_music_cover_default"];
    _titleImageView.layer.masksToBounds = YES;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_titleImageView];
    
    UIButton *scanningButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.right-16-ROUND_WIDTH_FLOAT(40), _titleImageView.bottom-16-ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
    [scanningButton addTarget:self action:@selector(didClickScanningButton:) forControlEvents:UIControlEventTouchUpInside];
    [scanningButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning"] forState:UIControlStateNormal];
    [scanningButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning_highlight"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:scanningButton];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = COMMON_TITLE_BG_COLOR;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(@49);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];

    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13.5);
        make.centerY.equalTo(bottomView);
    }];
    
    _addTaskButton = [UIButton new];
    [_addTaskButton addTarget:self action:@selector(didClickAddTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateNormal];
    [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:_addTaskButton];
    [_addTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(@(-13.5));
    }];
}

#pragma mark - Actions

- (void)didClickButton1:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene_highlight"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button1);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)didClickButton2:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest_highlight"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button2);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
        _scrollView.contentOffset = CGPointMake(self.view.width, 0);
    }];
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickAddTaskButton:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] strongholdService] addTaskWithID:_detail.id];
    _isAddTaskList = !_isAddTaskList;
    [self showTipsWith:_isAddTaskList];
}

- (void)showTipsWith:(BOOL)flag {
    UIView *_tipsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.width, 64)];
    [self.view addSubview:_tipsBackView];
    _tipsBackView.backgroundColor = COMMON_GREEN_COLOR;
    
    UIImageView *imageView;
    if (flag) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_addtask"]];
        [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateNormal];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskbook_deletesuccess"]];
        [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateNormal];
    }
    [_tipsBackView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tipsBackView.mas_centerX);
        make.centerY.equalTo(_tipsBackView.mas_centerY);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _tipsBackView.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:1.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _tipsBackView.top = -64;
                         }
                         completion:^(BOOL finished) {
                             [_tipsBackView removeFromSuperview];
                         }];
    }];

}

#pragma mark - Actions

- (void)didClickScanningButton:(UIButton *)sender {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _scrollView) {
//        NSLog(@"%lf", scrollView.contentOffset.x);
//        //得到图片移动相对原点的坐标
//        CGPoint point = scrollView.contentOffset;
//        
//        if (point.x > 2 * (SCREEN_WIDTH)) {
//            point.x = (SCREEN_WIDTH)* 2;
//            scrollView.contentOffset = point;
//        }
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    if (scrollView == _scrollView) {
//        //根据图片坐标判断页数
//        NSInteger index = round(targetContentOffset->x / (SCREEN_WIDTH));
//        NSLog(@"%ld", (long)index);
//        switch (index) {
//            case 0:
//                [self didClickButton1:nil];
//                break;
//            case 1:
//                [self didClickButton2:nil];
//                break;
//            default:
//                break;
//        }
//    }
}

@end
