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

@interface HTMascotIntroController () <UITableViewDelegate, UITableViewDataSource>

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
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backButton.origin = CGPointMake(11, 34);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view bringSubviewToFront:self.backButton];
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
        HTMascot *mascot = [[HTMascot alloc] init];
        mascot.mascotID = 3;
        [cell setMascot:mascot];
        return cell;
    } else {
        HTMascotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
        HTArticle *article = [[HTArticle alloc] init];
        article.mascotID = 3;
        article.articleTitle = @"这里是文章标题这是是文章";
        article.articleURL = @"www.baidu.com";
        [cell setArticle:article];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HTMascot *mascot = [[HTMascot alloc] init];
        mascot.mascotID = 3;
        return [HTMascotIntroCell calculateCellHeightWithMascot:mascot];
    } else {
        return 110;
    }
}

@end
