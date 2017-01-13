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

@implementation SKRankView {
    float lastOffsetY;
}

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
    self.tableView.layer.cornerRadius = 5;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
    
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
        } else if (indexPath.row == _rankerList.count-3) {
            SKRanker *ranker = _rankerList[indexPath.row +2];
            [cell showWithMe:NO];
            [cell setRanker:ranker withType:self.type];
            cell.separator.hidden = YES;
            return cell;
        } else {
            SKRanker *ranker = _rankerList[indexPath.row +2];
            [cell showWithMe:NO];
            [cell setRanker:ranker withType:self.type];
            cell.separator.hidden = NO;
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
            cell.separator.hidden = NO;
            return cell;
        } else if (indexPath.row == _rankerList.count-3) {
            SKRanker *ranker = _rankerList[indexPath.row +1];
            [cell showWithMe:NO];
            [cell setRanker:ranker withType:self.type];
            cell.separator.hidden = YES;
            return cell;
        } else {
            SKRanker *ranker = _rankerList[indexPath.row +1];
            [cell showWithMe:NO];
            [cell setRanker:ranker withType:self.type];
            cell.separator.hidden = NO;
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

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 64) {
        [UIView animateWithDuration:0.3 animations:^{
            [[self viewController].view viewWithTag:9001].alpha = 1;
            [[self viewController].view viewWithTag:201].alpha = 1;
            [[self viewController].view viewWithTag:202].alpha = 0;
            [[self viewController].view viewWithTag:9001].bottom = [[self viewController].view viewWithTag:9001].height+12;
            [[self viewController].view viewWithTag:201].bottom = [[self viewController].view viewWithTag:201].height;
            [[self viewController].view viewWithTag:202].bottom = [[self viewController].view viewWithTag:202].height;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        if (lastOffsetY >= scrollView.contentOffset.y) {
            [UIView animateWithDuration:0.3 animations:^{
                //显示
                [[self viewController].view viewWithTag:9001].alpha = 1;
                [[self viewController].view viewWithTag:201].alpha = 1;
                [[self viewController].view viewWithTag:202].alpha = 1;
                [[self viewController].view viewWithTag:9001].bottom = [[self viewController].view viewWithTag:9001].height+12;
                [[self viewController].view viewWithTag:201].bottom = [[self viewController].view viewWithTag:201].height;
                [[self viewController].view viewWithTag:202].bottom = [[self viewController].view viewWithTag:202].height;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                //隐藏
                [[self viewController].view viewWithTag:9001].alpha = 0;
                [[self viewController].view viewWithTag:201].alpha = 0;
                [[self viewController].view viewWithTag:202].alpha = 0;
                [[self viewController].view viewWithTag:9001].bottom = 0;
                [[self viewController].view viewWithTag:201].bottom = 0;
                [[self viewController].view viewWithTag:202].bottom = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    lastOffsetY = scrollView.contentOffset.y;
}

#pragma mark - Action

//获取View所在的Viewcontroller方法
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
