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

@interface HTMascotIntroController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat mascotRowHeight;
}

@property (nonatomic, strong) HTMascot *mascot;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *statusBarCoverView;        // 状态栏背后的颜色条

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
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HTMascotIntroCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotIntroCell class])];
    [self.tableView registerClass:[HTMascotArticleCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotArticleCell class])];
    
    self.statusBarCoverView = [[UIView alloc] init];
    self.statusBarCoverView.backgroundColor = [HTMascotHelper colorWithMascotIndex:_mascot.mascotID];
    self.statusBarCoverView.alpha = 0;
    [self.view addSubview:self.statusBarCoverView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backButton.origin = CGPointMake(11, 34);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.statusBarCoverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.statusBarCoverView];
}

#pragma mark - Action

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + _mascot.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HTMascotIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotIntroCell class]) forIndexPath:indexPath];
        [cell setMascot:self.mascot];
        return cell;
    } else {
        HTMascotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
        [cell setArticle:self.mascot.articles[indexPath.row - 1]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (mascotRowHeight == 0) mascotRowHeight = [HTMascotIntroCell calculateCellHeightWithMascot:self.mascot];
        return mascotRowHeight;
    } else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _statusBarCoverView.alpha = MIN(scrollView.contentOffset.y / (mascotRowHeight - 20), 1);
}

@end
