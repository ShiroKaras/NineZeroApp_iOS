//
//  HTCollectionController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/29.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTCollectionController.h"
#import "HTUIHeader.h"
#import "HTMascotArticleCell.h"
#import "MJRefresh.h"
#import "HTProfileArticlesController.h"
#import "HTArticleController.h"

@interface HTCollectionController ()
@property (nonatomic, strong) NSArray<HTArticle *> *articles;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏文章";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    [self.tableView registerClass:[HTMascotArticleCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotArticleCell class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getCollectArticlesWithPage:0 count:10 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        [HTProgressHUD dismiss];
        if (success) {
            _articles = articles;
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.5)];
            headerView.backgroundColor = [UIColor whiteColor];
            self.tableView.tableHeaderView = headerView;
            MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            NSMutableArray<UIImage *> *refreshingImages = [NSMutableArray array];
            for (int i = 0; i != 3; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"list_view_loader_grey_%d", (i + 1)]];
                [refreshingImages addObject:image];
            }
            [footer setImages:refreshingImages duration:1.0 forState:MJRefreshStateRefreshing];
            footer.refreshingTitleHidden = YES;
            self.tableView.mj_footer = footer;
            footer.height = 0;
            [self.tableView reloadData];
            if (_articles.count == 0) {
                UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
                converView.backgroundColor = COMMON_BG_COLOR;
                [self.view addSubview:converView];
                self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
                [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_big"] andOffset:17];
                [self.view addSubview:self.blankView];
                self.blankView.top = ROUND_HEIGHT_FLOAT(157);
            }
        }
    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(157);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTMascotArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
    HTArticle *article = _articles[indexPath.row];
    [cell setArticle:article];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTArticle *article = _articles[indexPath.row];
    HTArticleController *controller = [[HTArticleController alloc] initWithArticle:article];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

@end
