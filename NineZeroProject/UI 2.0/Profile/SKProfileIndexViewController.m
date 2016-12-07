//
//  SKProfileIndexViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/5.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileIndexViewController.h"
#import "HTUIHeader.h"

#import "SKProfileSettingViewController.h"
#import "SKProfileMyTicketsViewController.h"
#import "SKMyBadgesViewController.h"

@interface SKProfileIndexViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIView *backView1;
@property (nonatomic, strong) UIView *backView2;
@end

@implementation SKProfileIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakself);
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 40+86+16+20+12+76+10+304+10);
    [self.view addSubview:_scrollView];
    
    _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [_scrollView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(86, 86));
        make.top.equalTo(@40);
        make.centerX.equalTo(_scrollView);
    }];
    
    UIImageView *avatarWaveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default_big_deco"]];
    [_scrollView addSubview:avatarWaveImageView];
    [avatarWaveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 18));
        make.bottom.equalTo(_avatarImageView.mas_bottom);
        make.left.equalTo(_avatarImageView).offset(66);
    }];
    
    _usernameLabel = [UILabel new];
    _usernameLabel.text = @"用户名称";
    _usernameLabel.textColor = COMMON_GREEN_COLOR;
    _usernameLabel.font = PINGFANG_FONT_OF_SIZE(14);
    _usernameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_usernameLabel];
    [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_avatarImageView);
        make.height.equalTo(@20);
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(16);
    }];
    
    [self createBackView1];
    [self createBackView2];
    
    //设置
    UIButton *settingButton = [UIButton new];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_userptofiles_set"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_userptofiles_set_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.right.equalTo(weakself.view).offset(-4);
    }];
    
    //关闭
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

- (void)createBackView1 {
    //1
    _backView1 = [UIView new];
    _backView1.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView1.layer.cornerRadius = 5;
    [_scrollView addSubview:_backView1];
    [_backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 76));
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(_usernameLabel.mas_bottom).offset(12);
    }];
    
    //1.1
    UIView *rankView = [UIView new];
    [_backView1 addSubview:rankView];
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@((SCREEN_WIDTH-20)/3));
        make.height.equalTo(_backView1);
        make.left.equalTo(_backView1);
        make.centerY.equalTo(_backView1);
    }];
    
    UILabel *rankTitleLabel = [UILabel new];
    rankTitleLabel.text = @"排行";
    rankTitleLabel.textColor = [UIColor colorWithHex:0x4f4f4f];
    rankTitleLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [rankTitleLabel sizeToFit];
    [rankView addSubview:rankTitleLabel];
    [rankTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.centerX.equalTo(rankView);
    }];
    
    UILabel *rankLabel = [UILabel new];
    rankLabel.text = @"1K+";
    rankLabel.textColor = COMMON_PINK_COLOR;
    rankLabel.font = MOON_FONT_OF_SIZE(25);
    [rankLabel sizeToFit];
    [rankView addSubview:rankLabel];
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rankView);
        make.bottom.equalTo(rankView).offset(-12);
    }];
    
    //1.2
    UIView *coinView = [UIView new];
    [_backView1 addSubview:coinView];
    [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(rankView);
        make.centerX.equalTo(_backView1);
        make.centerY.equalTo(_backView1);
    }];
    
    UILabel *coinTitleLabel = [UILabel new];
    coinTitleLabel.text = @"金币";
    coinTitleLabel.textColor = rankTitleLabel.textColor;
    coinTitleLabel.font = rankTitleLabel.font;
    [coinTitleLabel sizeToFit];
    [coinView addSubview:coinTitleLabel];
    [coinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.centerX.equalTo(coinView);
    }];
    
    UILabel *coinLabel = [UILabel new];
    coinLabel.text = @"9999";
    coinLabel.textColor = rankLabel.textColor;
    coinLabel.font = rankLabel.font;
    [rankLabel sizeToFit];
    [rankView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(coinView);
        make.bottom.equalTo(coinView).offset(-12);
    }];
    
    //1.3
    UIView *diamondView = [UIView new];
    [_backView1 addSubview:diamondView];
    [diamondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(rankView);
        make.right.equalTo(_backView1);
        make.centerY.equalTo(_backView1);
    }];
    
    UILabel *diamondTitleLabel = [UILabel new];
    diamondTitleLabel.text = @"宝石";
    diamondTitleLabel.textColor = rankTitleLabel.textColor;
    diamondTitleLabel.font = rankTitleLabel.font;
    [diamondTitleLabel sizeToFit];
    [coinView addSubview:diamondTitleLabel];
    [diamondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.centerX.equalTo(diamondView);
    }];
    
    UILabel *diamondLabel = [UILabel new];
    diamondLabel.text = @"9999";
    diamondLabel.textColor = rankLabel.textColor;
    diamondLabel.font = rankLabel.font;
    [diamondLabel sizeToFit];
    [rankView addSubview:diamondLabel];
    [diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(diamondView);
        make.bottom.equalTo(diamondView).offset(-12);
    }];
}

- (void)createBackView2 {
    //2
    _backView2 = [UIView new];
    _backView2.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView2.layer.cornerRadius = 5;
    _backView2.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView2];
    [_backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 243));
        make.centerX.equalTo(_scrollView);
        make.top.equalTo(_backView1.mas_bottom).offset(10);
    }];
    
    NSArray *iconNameArray = @[@"img_userptofiles_gift", @"img_userptofiles_medal", @"img_userptofiles_thing", @"img_userptofiles_progress"];
    NSArray *titleArray = @[@"我的礼券", @"我的勋章", @"已收集的玩意儿", @"帮助我们进步"];
    NSArray *selectorNameArray = @[@"myTicketsClick", @"myBadgesClick", @"myThingsClick", @"helpUsClick"];
    
    for (int i = 0; i<4; i++) {
        UIView *view = [UIView new];
        [_backView2 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView2);
            make.height.equalTo(@60);
            make.top.equalTo(@(61*i));
            make.centerX.equalTo(_backView2);
        }];
        
        UIView *splitLine = [UIView new];
        splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
        [_backView2 addSubview:splitLine];
        [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(_backView2).offset(-10);
            make.height.equalTo(@1);
            make.top.equalTo(view.mas_bottom);
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconNameArray[i]]];
        [view addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(view);
            make.left.equalTo(@10);
        }];
        
        UILabel *label = [UILabel new];
        label.text = titleArray[i];
        label.textColor = [UIColor whiteColor];
        label.font = PINGFANG_FONT_OF_SIZE(16);
        [label sizeToFit];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(2);
            make.centerY.equalTo(view);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
        [arrowImageView sizeToFit];
        [view addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-20);
            make.centerY.equalTo(view);
        }];
        
        UILabel *countLabel = [UILabel new];
        countLabel.text = @"99+";
        countLabel.textColor = COMMON_PINK_COLOR;
        countLabel.font = MOON_FONT_OF_SIZE(14);
        [countLabel sizeToFit];
        [view addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-2);
            make.centerY.equalTo(view);
        }];
        
        UIButton *button = [UIButton new];
        [button addTarget:self action:NSSelectorFromString(selectorNameArray[i]) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(view);
            make.center.equalTo(view);
        }];
    }
}

#pragma mark - Actions

- (void)settingButtonClick:(UIButton*)sender {
    SKProfileSettingViewController *controller = [[SKProfileSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)myTicketsClick {
    SKProfileMyTicketsViewController *controller = [[SKProfileMyTicketsViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)myBadgesClick {
    SKMyBadgesViewController *controller = [[SKMyBadgesViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)myThingsClick {

}

- (void)helpUsClick {
    
}

@end
