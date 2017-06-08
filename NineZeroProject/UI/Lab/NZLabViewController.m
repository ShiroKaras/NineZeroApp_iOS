//
//  NZLabViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabViewController.h"
#import "HTUIHeader.h"

#import "NZLabTableViewCell.h"
#import "NZLabDetailViewController.h"
#import <PSCarouselView/PSCarouselView.h>

#import "HTWebController.h"

@interface NZLabViewController () <UITableViewDelegate, UITableViewDataSource, PSCarouselDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PSCarouselView *carouselView;

@property (nonatomic, strong) NSArray<SKBanner*> *bannerArray;
@property (nonatomic, strong) NSArray<SKTopic*>  *topicArray;

@end

@implementation NZLabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_labpage_title"]];
    [headerView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[NZLabTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else
        [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] topicService] getBannerListCallback:^(BOOL success, NSArray<SKBanner *> *bannerList) {
        self.bannerArray = bannerList;
        if ([bannerList count] > 0) {
            UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ROUND_WIDTH_FLOAT(180))];
            
            self.carouselView = [[PSCarouselView alloc] initWithFrame:tableViewHeaderView.frame];
            self.carouselView.placeholder = [UIImage imageNamed:@"img_banner_loading"];
            self.carouselView.contentMode = UIViewContentModeScaleAspectFill;
            self.carouselView.autoMoving = YES;
            self.carouselView.movingTimeInterval = 1.5f;
            [tableViewHeaderView addSubview:self.carouselView];
            NSMutableArray *urlArray = [NSMutableArray array];
            for (SKBanner *banner in bannerList) {
                [urlArray addObject:banner.banner_pic];
            }
            self.carouselView.imageURLs = urlArray;
            self.carouselView.pageDelegate = self;
            self.tableView.tableHeaderView = tableViewHeaderView;
        }
    }];
    
    [[[SKServiceManager sharedInstance] topicService] getTopicListCallback:^(BOOL success, NSArray<SKTopic *> *topicList) {
        _topicArray = topicList;
        [self.tableView reloadData];
    }];
}

- (void)didClickHeaderView {
    
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZLabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    if (cell==nil) {
        cell = [[NZLabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    }
    [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:_topicArray[indexPath.row].topic_list_pic]];
    cell.titleLabel.text = [_topicArray[indexPath.row].topic_title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZLabTableViewCell *cell = (NZLabTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NZLabDetailViewController *controller = [[NZLabDetailViewController alloc] initWithTopicID:_topicArray[indexPath.row].id];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topicArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - PSCarouselDelegate

- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page
{
    NSLog(@"Page:%ld", page);
    
}

- (void)carousel:(PSCarouselView *)carousel didTouchPage:(NSUInteger)page
{
    HTWebController *controller = [[HTWebController alloc] initWithURLString:self.bannerArray[page].link];
    controller.type = 1;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
