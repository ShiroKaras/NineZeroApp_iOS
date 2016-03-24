//
//  HTCollectionController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTCollectionController.h"
#import "HTUIHeader.h"
#import "HTMascotArticleCell.h"

@interface HTCollectionController ()
@property (nonatomic, strong) NSArray<HTArticle *> *articles;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏文章";
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.5)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[HTMascotArticleCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotArticleCell class])];
    
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getCollectArticlesWithPage:0 count:10 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        [HTProgressHUD dismiss];
        if (success) {
            _articles = articles;
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

@end
