//
//  SKRankView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKRankView.h"
#import "HTUIHeader.h"

#define REGISTER_CLASS(clazz)  [self.tableView registerClass:[clazz class] forCellReuseIdentifier:NSStringFromClass([clazz class])];

@interface SKRankView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign)   SKRankViewType  type;
@property (nonatomic, strong)   NSArray<SKRanker *> *rankerList;
@property (nonatomic, strong)   SKRanker *myRank;
@property (nonatomic, strong)   HTBlankView *blankView;
@property (nonatomic, strong)   UITableView *tableView;
@end

@implementation SKRankView

- (instancetype)initWithFrame:(CGRect)frame type:(SKRankViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    REGISTER_CLASS(HTProfileRankCell);
    
    self.rankerList = [NSArray array];
    _myRank = [[SKRanker alloc] init];
    _myRank.rank = [[SKStorageManager sharedInstance].profileInfo.rank integerValue];
    _myRank.user_avatar = [SKStorageManager sharedInstance].userInfo.user_avatar;
    _myRank.user_name = [SKStorageManager sharedInstance].userInfo.user_name;
    _myRank.gold = [SKStorageManager sharedInstance].profileInfo.user_gold;
    _myRank.user_experience_value = [SKStorageManager sharedInstance].profileInfo.user_experience_value;
    
    [HTProgressHUD show];
    
    if (self.type == SKRankViewTypeSeason1) {
        [[[SKServiceManager sharedInstance] profileService] getSeason1RankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
            if (success) {
                _rankerList = rankerList;
                [self.tableView reloadData];
                [HTProgressHUD dismiss];
            } else {
                [HTProgressHUD dismiss];
            }
        }];
    } else if (self.type == SKRankViewTypeSeason2) {
        [[[SKServiceManager sharedInstance] profileService] getSeason2RankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
            if (success) {
                _rankerList = rankerList;
                [self.tableView reloadData];
                [HTProgressHUD dismiss];
            } else {
                [HTProgressHUD dismiss];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_rankerList.count == 0) return 0;
    if (_rankerList.count > 100) {
        if (self.type == SKRankViewTypeSeason1)
            return 98;
        else if (self.type == SKRankViewTypeSeason2)
            return 99;
        else
            return 0;
    } else {
        if (self.type == SKRankViewTypeSeason1)
            return _rankerList.count - 2;
        else if (self.type == SKRankViewTypeSeason2)
            return _rankerList.count - 2;
        else
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SKRankViewTypeSeason1) {
        HTProfileRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRankCell class])   forIndexPath:indexPath];
        if (indexPath.row == 0) {
            NSArray<SKRanker*>* topRankers = [NSArray arrayWithObjects:_rankerList[0], _rankerList[1], _rankerList[2], nil];
            [cell setTopThreeRankers:topRankers withType:self.type];
            return cell;
        }else {
            SKRanker *ranker = _rankerList[indexPath.row +2];
            [cell setRanker:ranker withType:self.type];
            [cell showWithMe:NO];
            return cell;
        }
    } else if (self.type == SKRankViewTypeSeason2) {
        HTProfileRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRankCell class])   forIndexPath:indexPath];
        if (indexPath.row == 0) {
            NSArray<SKRanker*>* topRankers = [NSArray arrayWithObjects:_rankerList[0], _rankerList[1], _rankerList[2], nil];
            [cell setTopThreeRankers:topRankers withType:self.type];
            return cell;
        } else if (indexPath.row == 1) {
            [cell setRanker:_myRank withType:self.type];
            [cell showWithMe:YES];
            return cell;
        } else {
            SKRanker *ranker = _rankerList[indexPath.row +1];
            [cell setRanker:ranker withType:self.type];
            [cell showWithMe:NO];
            return cell;
        }
    } else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (SCREEN_WIDTH-32)/288.*281.;
    } else {
        return 74;
    }
}

@end
