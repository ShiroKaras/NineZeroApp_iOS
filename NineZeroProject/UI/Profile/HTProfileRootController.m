//
//  HTProfileRootController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileRootController.h"
#import "HTProfileSettingController.h"
#import "HTCollectionController.h"
#import "HTNotificationController.h"
#import "HTUIHeader.h"

@interface HTProfileRootController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AvatarTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

@end

@implementation HTProfileRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        self.AvatarTopConstraint.   constant = 63;
    } else if (SCREEN_WIDTH ==IPHONE6_SCREEN_WIDTH) {
        self.AvatarTopConstraint.constant = 100;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        self.AvatarTopConstraint.constant = 140;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)didClickBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickNotification:(UIButton *)sender {
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)didClickSetting:(UIButton *)sender {
    HTProfileSettingController *settingController = [[HTProfileSettingController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (IBAction)didClickCoin:(UIButton *)sender {

}

- (IBAction)didClickRank:(UIButton *)sender {
}

- (IBAction)didClickMedal:(UIButton *)sender {
}

- (IBAction)didClickCollectionArticle:(UIButton *)sender {
    HTCollectionController *collectionController = [[HTCollectionController alloc] init];
    [self.navigationController pushViewController:collectionController animated:YES];
}

- (IBAction)didClickReward:(UIButton *)sender {
}


@end
