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
    
    [[[HTServiceManager sharedInstance] profileService] getCollectArticlesWithPage:0 count:10 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        if (success) {
            _articles = articles;
            [self.tableView reloadData];
        }
    }];
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
