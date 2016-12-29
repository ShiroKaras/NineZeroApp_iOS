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

@interface SKRankViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) SKRankViewType type;
@end

@implementation SKRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    SKRankView *view2 = [[SKRankView alloc] initWithFrame:self.view.bounds type:SKRankViewTypeSeason1];
    view2.tag = 100;
    [self.view addSubview:view2];
    
    SKRankView *view = [[SKRankView alloc] initWithFrame:self.view.bounds type:SKRankViewTypeSeason2];
    view.tag = 101;
    [self.view addSubview:view];
    
    self.type = SKRankViewTypeSeason2;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rank_shading"]];
    backImageView.tag = 202;
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backImageView];
    
    UIButton *changeSeasonButton = [UIButton new];
    changeSeasonButton.tag = 201;
    [changeSeasonButton addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    [changeSeasonButton setBackgroundImage:[UIImage imageNamed:@"btn_rank_season1"] forState:UIControlStateNormal];
    [self.view addSubview:changeSeasonButton];
    [changeSeasonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 66));
        make.top.equalTo(@0);
        make.right.equalTo(@(-16));
    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:blankView];
        blankView.top = ROUND_HEIGHT_FLOAT(217);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"rankingpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"rankingpage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

//- (void)closeButtonClick:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
        [TalkingData trackEvent:@"lastseason"];
        self.type = SKRankViewTypeSeason1;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_rank_season2"] forState:UIControlStateNormal];
    } else if (self.type == SKRankViewTypeSeason1) {
        [TalkingData trackEvent:@"theseason"];
        self.type = SKRankViewTypeSeason2;
        [sender setBackgroundImage:[UIImage imageNamed:@"btn_rank_season1"] forState:UIControlStateNormal];
    }
}


@end
