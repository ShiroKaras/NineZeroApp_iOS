//
//  SKProfileSettingViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/5.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileSettingViewController.h"
#import "HTUIHeader.h"

@interface SKProfileSettingViewController ()
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *backView1;
@property (nonatomic, strong) UIView        *backView2;
@property (nonatomic, strong) UIView        *backView3;
@end

@implementation SKProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakself);
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"设置";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(20);
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(@19);
    }];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 360+50+40);
    [self.view addSubview:_scrollView];
    
    [self createBackView1];
    [self createBackView2];
    [self createBackView3];
    
    UIButton *quitButton = [UIButton new];
    quitButton.backgroundColor = [UIColor colorWithHex:0xed203b];
    quitButton.layer.cornerRadius = 5;
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:quitButton];
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@(50));
        make.top.equalTo(_backView3.mas_bottom).offset(10);
        make.centerX.equalTo(_scrollView);
    }];
}

- (void)createBackView1 {
    _backView1 = [UIView new];
    _backView1.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView1.layer.cornerRadius = 5;
    _backView1.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView1];
    [_backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
 
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView1 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView1).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView1 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView1);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView1);
            make.top.equalTo(@(61*i));
        }];
        
        if (i==0) {
            UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
            avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:avatarImageView];
            [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@40);
                make.height.equalTo(@40);
                make.centerY.equalTo(view);
                make.left.equalTo(@20);
            }];
        } else if (i==1) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = @"用户昵称";
            titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
            [titleLabel sizeToFit];
            [view addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(@20);
            }];
        }
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
        [arrowImageView sizeToFit];
        [view addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
        }];
        
        UILabel *infoLabel = [UILabel new];
        infoLabel.textColor = [UIColor whiteColor];
        if (i == 0)     infoLabel.text = @"修改头像";
        else if (i == 1)     infoLabel.text = @"修改昵称";
        infoLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [view addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-5);
            make.centerY.equalTo(view);
        }];
    }
}

- (void)createBackView2 {
    _backView2 = [UIView new];
    _backView2.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView2.layer.cornerRadius = 5;
    _backView2.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView2];
    [_backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView1.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView2 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView2).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView2 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView2);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView2);
            make.top.equalTo(@(61*i));
        }];
        
        if (i == 0) {
            UISwitch *notificationSwitch = [UISwitch new];
            notificationSwitch.onTintColor = COMMON_GREEN_COLOR;
            [view addSubview:notificationSwitch];
            [notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-20);
            }];
        } else if (i == 1) {
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
            [arrowImageView sizeToFit];
            [view addSubview:arrowImageView];
            [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-20);
            }];
        }
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        if (i == 0)     titleLabel.text = @"消息推送";
        else if (i == 1)     titleLabel.text = @"清除缓存";
        titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view);
        }];
    }
}

- (void)createBackView3 {
    _backView3 = [UIView new];
    _backView3.backgroundColor = COMMON_SEPARATOR_COLOR;
    _backView3.layer.cornerRadius = 5;
    _backView3.layer.masksToBounds = YES;
    [_scrollView addSubview:_backView3];
    [_backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView2.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@121);
        make.centerX.equalTo(_scrollView);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
    [_backView3 addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(_backView3).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(@61);
    }];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [UIView new];
        [_backView3 addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_backView3);
            make.height.equalTo(@60);
            make.centerX.equalTo(_backView3);
            make.top.equalTo(@(61*i));
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_userptofiles_nextpage"]];
        [arrowImageView sizeToFit];
        [view addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(-20);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        if (i == 0)     titleLabel.text = @"关于";
        else if (i == 1)     titleLabel.text = @"什么是九零";
        titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(20);
            make.centerY.equalTo(view);
        }];
        
        if (i==0) {
            UILabel *infoLabel = [UILabel new];
            infoLabel.text =  [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            infoLabel.textColor = [UIColor whiteColor];
            infoLabel.font = PINGFANG_FONT_OF_SIZE(14);
            [view addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowImageView.mas_left).offset(-5);
                make.centerY.equalTo(view);
            }];
        }
    }
}

@end
