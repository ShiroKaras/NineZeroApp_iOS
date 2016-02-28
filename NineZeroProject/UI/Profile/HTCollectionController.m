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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTMascotArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
    HTArticle *article = [[HTArticle alloc] init];
    article.articleTitle = @"这里是文章标题这里是文章";
    article.mascotID = 1;
    [cell setArticle:article];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

@end
