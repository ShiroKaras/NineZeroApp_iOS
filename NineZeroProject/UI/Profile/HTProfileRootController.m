//
//  HTProfileRootController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
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
#import "HTPreviewCardController.h"
#import "HTCardCollectionCell.h"
//#import "HTArticleController.h"
#import "HTWebController.h"

@interface HTProfileRootController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HTProfileRecordCellDelegate, HTPreviewCardControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AvatarTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *metaLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIView *recordBackView;
@property (weak, nonatomic) IBOutlet UIImageView *notificationFlagImageView;

@property (nonatomic, strong) UICollectionView *recordView;
@property (nonatomic, strong) HTProfileInfo *profileInfo;
@property (nonatomic, strong) HTUserInfo *userInfo;
@property (nonatomic, strong) HTBlankView *blankView;

@property (nonatomic, strong) UIImageView *animatedImageView;
@property (nonatomic, strong) HTCardCollectionCell *snapView;
@property (nonatomic, assign) CGRect animatedFromFrame;
@property (nonatomic, assign) CGRect animatedToFrame;
@property (nonatomic, strong) UIView *snapCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameBottonConstraint;

@end

@implementation HTProfileRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        self.AvatarTopConstraint.constant = 63;
    } else if (SCREEN_WIDTH ==IPHONE6_SCREEN_WIDTH) {
        self.AvatarTopConstraint.constant = 66;
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        self.AvatarTopConstraint.constant = 100;
    }
    
    _avatar.layer.cornerRadius = _avatar.width / 2;
    _avatar.layer.masksToBounds = YES;
    _avatar.userInteractionEnabled = NO;
    
    _notificationFlagImageView.hidden = YES;
    
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
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"homepage"];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO) {
        _profileInfo.answer_list = nil;
        _recordView.hidden = YES;
        
        if (self.blankView == nil) {
            self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
            [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_small"] andOffset:12];
            [self.view addSubview:self.blankView];
        } else {
            [self.view bringSubviewToFront:self.blankView];
        }
        
        [self reloadData];
    } else {
        _recordView.hidden = NO;
        [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
            if (success) {
                _profileInfo = profileInfo;
                if (_profileInfo.answer_list.count == 0) {
                    if (self.blankView == nil) {
                        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
                        [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_small"] andOffset:9];
                        [self.view addSubview:self.blankView];
                    } else {
                        [self.view bringSubviewToFront:self.blankView];
                    }
                }
                if([_profileInfo.notice integerValue]+1 - [UD integerForKey:@"notificationsHasReadKey"]>0)
                    self.notificationFlagImageView.hidden = NO;
                else
                    self.notificationFlagImageView.hidden = YES;
                [self reloadData];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"homepage"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _recordView.frame = _recordBackView.bounds;
    _blankView.top = ROUND_HEIGHT_FLOAT(67) + _recordBackView.top;
}

- (void)reloadData {
    _coinLabel.text = _profileInfo.gold;
    _rankLabel.text = [_profileInfo.rank integerValue]>999?@"1000+":_profileInfo.rank;
    _rewardLabel.text = _profileInfo.ticket;
    _metaLabel.text = _profileInfo.medal;
    _collectionLabel.text = _profileInfo.article;
    _nickName.text = _userInfo.user_name;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_userInfo.user_avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_profile_photo_default_big"]];
    [_recordView reloadData];
}

- (IBAction)didClickBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickNotification:(UIButton *)sender {
    [MobClick event:@"push"];
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)didClickSetting:(UIButton *)sender {
    HTProfileSettingController *settingController = [[HTProfileSettingController alloc] initWithUserInfo:_userInfo];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (IBAction)didClickCoin:(UIButton *)sender {
    [MobClick event:@"goldcoin"];
    HTWebController *webController = [[HTWebController alloc] init];
    [webController setUrlString:[NSString stringWithFormat:@"http://admin.90app.tv/index.php?s=/Home/user/coin/id/%@", [[HTStorageManager sharedInstance] getUserID]]];
    webController.title = @"金币";
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)didClickRank:(UIButton *)sender {
    [MobClick event:@"rankinglist"];
    HTProfileRankController *rankController = [[HTProfileRankController alloc] init];
    [self.navigationController pushViewController:rankController animated:YES];
}

- (IBAction)didClickMedal:(UIButton *)sender {
    [MobClick event:@"badge"];
    HTProfileBadgeController *badgeController = [[HTProfileBadgeController alloc] init];
    [self.navigationController pushViewController:badgeController animated:YES];
}

- (IBAction)didClickCollectionArticle:(UIButton *)sender {
    [MobClick event:@"Cessay"];
    HTCollectionController *collectionController = [[HTCollectionController alloc] init];
    [self.navigationController pushViewController:collectionController animated:YES];
}

- (IBAction)didClickReward:(UIButton *)sender {
    [MobClick event:@"gift"];
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
    if (_profileInfo.answer_list.count != 0) {
        DLog(@"Index:%ld", (long)indexPath.row)
        DLog(@"answerList->%@", _profileInfo.answer_list[indexPath.row].question_video_cover);
        [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:_profileInfo.answer_list[indexPath.row].question_video_cover] placeholderImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
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

#pragma mark - HTProfileRecordCell Delegate

- (void)onClickedPlayButtonInCollectionCell:(HTProfileRecordCell *)cell {
    NSArray<HTQuestion *> *questionList = _profileInfo.answer_list;
    if (questionList.count <= 0) return;
    _snapCell = [cell.coverImageView snapshotViewAfterScreenUpdates:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIImage *bgImage;
    if (SCREEN_WIDTH <= IPHONE5_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_640×1136"];
    } else if (SCREEN_WIDTH >= IPHONE6_PLUS_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_1242x2208"];
    } else {
        bgImage = [UIImage imageNamed:@"bg_success_750x1334"];
    }
    _animatedImageView = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    _animatedImageView.image = bgImage;
    [self.view addSubview:_animatedImageView];
    _animatedImageView.alpha = 0;
    
    NSInteger index = MAX(0, MIN(questionList.count, cell.indexPath.row));
    HTQuestionInfo *questionInfo = [[[HTServiceManager sharedInstance] questionService] questionInfo];
    HTQuestion *question = questionList[index];
    _snapView = [[HTCardCollectionCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_snapView setQuestion:question questionInfo:questionInfo];
    
    _animatedFromFrame = [cell convertRect:cell.coverImageView.frame toView:self.view];
    _animatedToFrame = CGRectMake(30, ROUND_HEIGHT_FLOAT(96), SCREEN_WIDTH - 47, SCREEN_WIDTH - 47);
    _snapView.frame = _animatedFromFrame;
    [self.view addSubview:_snapView];
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _snapView.frame = _animatedToFrame;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:duration animations:^{
        _animatedImageView.alpha = 1.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - 0.2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray<HTQuestion *>* questionArray = @[question];
        HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeIndexRecord andQuestList:questionArray];
        cardController.delegate = self;
        cardController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:cardController animated:YES completion:^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [_snapView removeFromSuperview];
        }];
    });
}

#pragma mark - HTPreviewCardController

- (void)didClickCloseButtonInController:(HTPreviewCardController *)controller {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [controller dismissViewControllerAnimated:NO completion:^{
        _snapCell.frame = _animatedToFrame;
        [self.view addSubview:_snapCell];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _snapCell.frame = _animatedFromFrame;
            _animatedImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [_snapCell removeFromSuperview];
            [_animatedImageView removeFromSuperview];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }];
}

@end
