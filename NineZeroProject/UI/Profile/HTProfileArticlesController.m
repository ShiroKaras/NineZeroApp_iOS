//
//  HTProfileArticlesController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileArticlesController.h"
#import "HTUIHeader.h"
#import "HTProfileArticleCell.h"

@interface HTProfileArticlesController ()
@property (nonatomic, strong) NSArray<HTArticle *> *articles;
@end

@implementation HTProfileArticlesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [HTUIHelper commonLeftBarItem];
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"往期文章";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HTProfileArticleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HTProfileArticleCellIdentifier"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    UIImageView *footerViewDeco = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_archive_deco"]];
    footerViewDeco.right = SCREEN_WIDTH - 17;
    footerViewDeco.top = 16;
    [footerView addSubview:footerViewDeco];
    self.tableView.tableFooterView = footerView;
    
    [[[HTServiceManager sharedInstance] profileService] getArticlesInPastWithPage:0 count:10 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        if (success) {
            _articles = articles;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTProfileArticleCellIdentifier" forIndexPath:indexPath];
    HTArticle *article = _articles[indexPath.row];
    [cell setArticle:article];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

@end
