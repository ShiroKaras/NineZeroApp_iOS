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
#import "HTProfileRankController.h"
#import "HTProfileRewardController.h"
#import "HTProfileBadgeController.h"
#import "HTProfileRecordCell.h"
#import "HTUIHeader.h"

@interface HTProfileRootController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HTProfileRecordCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AvatarTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIView *recordBackView;
@property (nonatomic, strong) UICollectionView *recordView;
@property (nonatomic, strong) HTProfileInfo *profileInfo;
@property (nonatomic, strong) HTUserInfo *userInfo;
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
    
    
    _avatar.layer.cornerRadius = _avatar.width / 2;
    _avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _recordView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _recordView.delegate = self;
    _recordView.dataSource = self;
    _recordView.backgroundColor = [UIColor clearColor];
    [_recordBackView addSubview:_recordView];
    
    [_recordView registerClass:[HTProfileRecordCell class] forCellWithReuseIdentifier:NSStringFromClass([HTProfileRecordCell class])];
    
    _profileInfo = [[HTStorageManager sharedInstance] profileInfo];
    _userInfo = [[HTStorageManager sharedInstance] userInfo];
    
    [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
        if (success) {
            _profileInfo = profileInfo;
            [self reloadData];
            [[HTStorageManager sharedInstance] setProfileInfo:profileInfo];
        }
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            _userInfo = userInfo;
            [self reloadData];
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _recordView.frame = _recordBackView.bounds;
}

- (void)reloadData {
    _coinLabel.text = _profileInfo.gold;
    _rankLabel.text = _profileInfo.rank;
    _rewardLabel.text = _profileInfo.ticket;
    _metaLabel.text = _profileInfo.medal;
    _collectionLabel.text = _profileInfo.article;
    _nickName.text = _userInfo.user_name;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_userInfo.user_avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_profile_photo_default_big"]];
    [_recordView reloadData];
}

//- (NSString *)truncatingWithString:(NSString *)string {
//    NSUInteger number = [string integerValue];
//    if (number > )
//}

- (IBAction)didClickBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickNotification:(UIButton *)sender {
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)didClickSetting:(UIButton *)sender {
    HTProfileSettingController *settingController = [[HTProfileSettingController alloc] initWithUserInfo:_userInfo];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (IBAction)didClickCoin:(UIButton *)sender {

}

- (IBAction)didClickRank:(UIButton *)sender {
    HTProfileRankController *rankController = [[HTProfileRankController alloc] init];
    [self.navigationController pushViewController:rankController animated:YES];
}

- (IBAction)didClickMedal:(UIButton *)sender {
    HTProfileBadgeController *badgeController = [[HTProfileBadgeController alloc] init];
    [self.navigationController pushViewController:badgeController animated:YES];
}

- (IBAction)didClickCollectionArticle:(UIButton *)sender {
    HTCollectionController *collectionController = [[HTCollectionController alloc] init];
    [self.navigationController pushViewController:collectionController animated:YES];
}

- (IBAction)didClickReward:(UIButton *)sender {
    HTProfileRewardController *rewardController = [[HTProfileRewardController alloc] init];
    [self.navigationController pushViewController:rewardController animated:YES];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _profileInfo.answer_list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTProfileRecordCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_recordBackView.height - 58, _recordBackView.height - 58);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(28, 9, 0, 9);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(HTProfileRecordCell *)cell stop];
}

#pragma mark - HTProfileRecordCell Delegate

- (void)onClickedPlayButtonInCollectionCell:(HTProfileRecordCell *)cell {
    for (HTProfileRecordCell *iter in [_recordView visibleCells]) {
        if (cell != iter) {
            [iter stop];
        }
    }
}

@end
