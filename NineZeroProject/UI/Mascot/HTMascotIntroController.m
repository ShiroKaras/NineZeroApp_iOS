//
//  HTMascotIntroController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotIntroController.h"
#import "HTUIHeader.h"
#import "HTMascotIntroCell.h"
#import "HTMascotArticleCell.h"
#import "HTArticleController.h"

@interface HTMascotIntroController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat mascotRowHeight;
}

@property (nonatomic, strong) HTMascot *mascot;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *statusBarCoverView;        // 状态栏背后的颜色条
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UIView *blankCoverView;
@property (nonatomic, assign) CGFloat headerViewHeight;

@end

@implementation HTMascotIntroController

- (instancetype)initWithMascot:(HTMascot *)mascot {
    if (self = [super init]) {
        _mascot = mascot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back_highlight"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    [self.view addSubview:self.backButton];

    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share_highlight"] forState:UIControlStateHighlighted];
    [self.shareButton addTarget:self action:@selector(onClickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton sizeToFit];
    [self.view addSubview:self.shareButton];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HTMascotIntroCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotIntroCell class])];
    [self.tableView registerClass:[HTMascotArticleCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotArticleCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.statusBarCoverView = [[UIView alloc] init];
    self.statusBarCoverView.backgroundColor = [HTMascotHelper colorWithMascotIndex:_mascot.mascotID];
    self.statusBarCoverView.alpha = 0;
    [self.view addSubview:self.statusBarCoverView];
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO) {
        _mascot.articles = nil;
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_light_grey_small"] andOffset:11];
        [self.view addSubview:self.blankView];
        [self.tableView reloadData];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1000)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
        self.tableView.scrollEnabled = NO;
    } else {
        if (_mascot.articles.count == 0) {
            self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
            [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_small"] andOffset:11];
            [self.view addSubview:self.blankView];
            [self.tableView reloadData];
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1000)];
            footerView.backgroundColor = [UIColor whiteColor];
            self.tableView.tableFooterView = footerView;
            self.tableView.scrollEnabled = NO;
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backButton.origin = CGPointMake(11, 34);
    self.shareButton.top = self.backButton.top;
    self.shareButton.right = SCREEN_WIDTH - 11;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.statusBarCoverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [self.view sendSubviewToBack:self.tableView];
    
    self.blankView.top = 27 + _headerViewHeight;
}

#pragma mark - Action

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickShareButton {
    
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mascot.articles.count == 0) return 1;
    return 2 + _mascot.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HTMascotIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotIntroCell class]) forIndexPath:indexPath];
        [cell setMascot:self.mascot];
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else {
        HTMascotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
        [cell setArticle:self.mascot.articles[indexPath.row - 2]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (mascotRowHeight == 0) mascotRowHeight = [HTMascotIntroCell calculateCellHeightWithMascot:self.mascot];
        _headerViewHeight = mascotRowHeight;
        return mascotRowHeight;
    } else if (indexPath.row == 1) {
        return 15;
    } else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        HTArticleController *articleController = [[HTArticleController alloc] initWithArticle:self.mascot.articles[indexPath.row - 2]];
        [self presentViewController:articleController animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _statusBarCoverView.alpha = MIN(scrollView.contentOffset.y / (mascotRowHeight - 20), 1);
    _shareButton.alpha = 1 - _statusBarCoverView.alpha;
}

@end
