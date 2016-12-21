//
//  SKRankViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKRankViewController.h"
#import "HTUIHeader.h"
#import "SKRankView.h"

@interface SKRankViewController ()
@property (nonatomic, assign) SKRankViewType type;
@end

@implementation SKRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKRankView *view2 = [[SKRankView alloc] initWithFrame:self.view.bounds type:SKRankViewTypeSeason1];
    view2.tag = 100;
    [self.view addSubview:view2];
    
    SKRankView *view = [[SKRankView alloc] initWithFrame:self.view.bounds type:SKRankViewTypeSeason2];
    view.tag = 101;
    [self.view addSubview:view];
    
    self.type = SKRankViewTypeSeason2;
    
    UIButton *changeSeasonButton = [UIButton new];
    [changeSeasonButton addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    [changeSeasonButton setBackgroundImage:[UIImage imageNamed:@"btn_rank_season1"] forState:UIControlStateNormal];
    [self.view addSubview:changeSeasonButton];
    [changeSeasonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
        make.top.equalTo(@12);
        make.right.equalTo(@(-4));
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)flip:(id)sender{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    //这里时查找视图里的子视图（这种情况查找，可能时因为父视图里面不只两个视图）
    NSInteger fist= [[self.view subviews] indexOfObject:[self.view viewWithTag:100]];
    NSInteger seconde= [[self.view subviews] indexOfObject:[self.view viewWithTag:101]];
    
    [self.view exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    
    //当父视图里面只有两个视图的时候，可以直接使用下面这段.
    
    //[self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
    if (self.type == SKRankViewTypeSeason2) {
        self.type = SKRankViewTypeSeason1;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_rank_season2"] forState:UIControlStateNormal];
    } else if (self.type == SKRankViewTypeSeason1) {
        self.type = SKRankViewTypeSeason2;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_rank_season1"] forState:UIControlStateNormal];
    }
}


@end
