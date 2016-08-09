//
//  SKRankInQuestionTableViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/8/4.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKRankInQuestionViewController.h"
#import "SKRankInQuestionTableViewCell.h"
#import "HTUIHeader.h"

@interface SKRankInQuestionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<HTRanker *> *rankerList;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) HTLoginButton *completeButton;
@end

@implementation SKRankInQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SKRankInQuestionTableViewCell class] forCellReuseIdentifier:@"RankCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RankCellHeader"];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.alpha = 0.9;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    _completeButton = [HTLoginButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    _completeButton.enabled = YES;
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton addTarget:self action:@selector(onClickCompleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_completeButton];
    
    self.rankerList = [NSArray array];
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] questionService] getRankListWithQuestion:_questionID callback:^(BOOL success, NSArray<HTRanker *> *ranker) {
        if (success) {
            [HTProgressHUD dismiss];
            _rankerList = ranker;
            [self.tableView reloadData];
        } else {
            [HTProgressHUD dismiss];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Aciton

- (void)onClickCompleteButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankerList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankCellHeader" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chapter_leaderboard"]];
        [image sizeToFit];
        [cell addSubview:image];
        image.top = 45;
        image.centerX = cell.centerX;
        return cell;
    } else {
        SKRankInQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        
        HTRanker *ranker = _rankerList[indexPath.row - 1];
        [cell setRanker:ranker];
        
        return cell;
    }
    
}

#pragma mark - Table view delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 45+29+12.5;
    else
        return 100;
}

@end
