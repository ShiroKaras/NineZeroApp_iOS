//
//  SKNotificationRootViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/22.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKNotificationRootViewController.h"
#import "HTUIHeader.h"

#import "HTNotificationController.h"
#import "ChatFlowViewController.h"

@interface SKNotificationRootViewController ()
@property (nonatomic, strong) UILabel *systemNotificaitonContent;
@property (nonatomic, strong) UILabel *secretaryContent;
@property (nonatomic, assign) int noticeCount;
@property (nonatomic, assign) int secretaryCount;
@end

@implementation SKNotificationRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(weakself);
    self.view.backgroundColor = [UIColor blackColor];
    
    //标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"消息通知";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(17);
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(@19);
    }];
    
    //系统消息
    UIView *systemNotificationButton = [UIView new];
    systemNotificationButton.layer.cornerRadius = 5;
    systemNotificationButton.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:systemNotificationButton];
    [systemNotificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 64));
        make.top.equalTo(@(64));
        make.centerX.equalTo(weakself.view);
    }];
    
    UIImageView *systemNotificationIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_notice_system"]];
    [systemNotificationButton addSubview:systemNotificationIconImageView];
    [systemNotificationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@(12));
        make.centerY.equalTo(systemNotificationButton);
    }];
    
    UILabel *systemNotificationTitleLabel = [UILabel new];
    systemNotificationTitleLabel.text = @"系统消息";
    systemNotificationTitleLabel.textColor = [UIColor whiteColor];
    systemNotificationTitleLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [systemNotificationTitleLabel sizeToFit];
    [systemNotificationButton addSubview:systemNotificationTitleLabel];
    [systemNotificationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(13));
        make.left.equalTo(@(64));
    }];
    
    //系统通知
    _systemNotificaitonContent = [UILabel new];
    _systemNotificaitonContent.text = @"";
    _systemNotificaitonContent.textColor = [UIColor colorWithHex:0xc3c3c3];
    _systemNotificaitonContent.font = PINGFANG_FONT_OF_SIZE(10);
    [_systemNotificaitonContent sizeToFit];
    [systemNotificationButton addSubview:_systemNotificaitonContent];
    [_systemNotificaitonContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(systemNotificationTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(systemNotificationTitleLabel);
        make.right.equalTo(systemNotificationButton.mas_right).offset(-12);
    }];
    
    //零仔小秘书
    UIView *secretaryButton = [UIView new];
    secretaryButton.layer.cornerRadius = 5;
    secretaryButton.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:secretaryButton];
    [secretaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, 64));
        make.top.equalTo(@(138));
        make.centerX.equalTo(weakself.view);
    }];
    
    UIImageView *secretaryIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_notice_secretary"]];
    [secretaryButton addSubview:secretaryIconImageView];
    [secretaryIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@(12));
        make.centerY.equalTo(secretaryButton);
    }];
    
    UILabel *secretaryTitleLabel = [UILabel new];
    secretaryTitleLabel.text = @"零仔小秘书";
    secretaryTitleLabel.textColor = [UIColor whiteColor];
    secretaryTitleLabel.font = systemNotificationTitleLabel.font;
    [secretaryTitleLabel sizeToFit];
    [secretaryButton addSubview:secretaryTitleLabel];
    [secretaryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(13));
        make.left.equalTo(@(64));
    }];
    
    //小秘书
    _secretaryContent = [UILabel new];
    _secretaryContent.text = @"";
    _secretaryContent.textColor = _systemNotificaitonContent.textColor;
    _secretaryContent.font = _systemNotificaitonContent.font;
    [_secretaryContent sizeToFit];
    [secretaryButton addSubview:_secretaryContent];
    [_secretaryContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secretaryTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(secretaryTitleLabel);
        make.right.equalTo(secretaryButton.mas_right).offset(-12);
    }];
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_notice_banner"]];
    bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.view);
        make.centerX.equalTo(weakself.view);
        make.width.equalTo(weakself.view);
        make.height.mas_equalTo(SCREEN_WIDTH/320*210);
    }];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickNotificationButton)];
    [systemNotificationButton addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickSecretaryButton)];
    [secretaryButton addGestureRecognizer:tap2];
    
    [self loadData];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] secretaryService] showSecretaryNoticeListWithCallback:^(BOOL success, SKResponsePackage *response) {
        _systemNotificaitonContent.text = response.data[@"notice"][@"notice_last_one"];
        _noticeCount = [response.data[@"notice"][@"notice_count"] intValue];
        
        _secretaryContent.text = response.data[@"secretary"][@"secretary_last_one"];
        _secretaryCount = [response.data[@"secretary"][@"secretary_count"] intValue];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (void)onClickNotificationButton {
    [UD setValue:@(_noticeCount) forKey:NOTIFICATION_COUNT];
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickSecretaryButton {
    [UD setValue:@(_secretaryCount) forKey:SECRETARY_COUNT];
    ChatFlowViewController *controller = [[ChatFlowViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
