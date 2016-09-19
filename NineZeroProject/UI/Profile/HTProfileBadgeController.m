//
//  HTProfileBadgeController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/12.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileBadgeController.h"
#import "HTProfileRankCell.h"
#import "HTProfileBadgeCollectionCell.h"
#import "HTUIHeader.h"
#import "HTDescriptionView.h"

@interface HTBadgeHeaderView : UICollectionReusableView
@property (nonatomic, strong) UIImageView *headerBackView;
@property (nonatomic, strong) UIImageView *numberCircleView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *coinNumberLabel;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) HTProfileProgressView *progressView;
@property (nonatomic, strong) HTProfileInfo *profileInfo;
@end
@implementation HTBadgeHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _headerBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_badge_cover"]];
        if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
            _headerBackView.image = [UIImage imageNamed:@"img_profile_badge_cover_750x320"];
        } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
            _headerBackView.image = [UIImage imageNamed:@"img_profile_badge_cover_1242x480"];
        }
        [self addSubview:_headerBackView];
        
        _numberCircleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_badge_cover_circle"]];
        [self addSubview:_numberCircleView];
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"1";
        _numberLabel.textColor = [UIColor colorWithHex:0xfdd900];
        _numberLabel.font = MOON_FONT_OF_SIZE(26);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [_numberLabel sizeToFit];
        [self addSubview:_numberLabel];
        
        _coinNumberLabel = [[UILabel alloc] init];
        _coinNumberLabel.text = @"24";
        _coinNumberLabel.textColor = [UIColor colorWithHex:0xfdd900];
        _coinNumberLabel.font = MOON_FONT_OF_SIZE(15);
        _coinNumberLabel.textAlignment = NSTextAlignmentLeft;
        [_coinNumberLabel sizeToFit];
        [self addSubview:_coinNumberLabel];
        
        _progressView = [[HTProfileProgressView alloc] initWithFrame:CGRectZero];
        [_progressView setProgress:0.5];
        [_progressView setBackColor:[UIColor whiteColor]];
        [_progressView setCoverColor:[UIColor colorWithHex:0xfdd900]];
        [self addSubview:_progressView];
        
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_badge_cover_txt"]];
        [self addSubview:_tipImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _headerBackView.frame = self.bounds;
    _numberCircleView.centerX = self.width / 2;
    _numberCircleView.top = 27;
    _numberLabel.center = _numberCircleView.center;
    _numberLabel.top = _numberLabel.top + 1;
    _tipImageView.top = _numberCircleView.bottom + 8;
    _tipImageView.centerX = self.width / 2 - _coinNumberLabel.width / 2;
    [_coinNumberLabel sizeToFit];
    _coinNumberLabel.left = _tipImageView.right + 0.5;
    _coinNumberLabel.centerY = _tipImageView.centerY;
    _progressView.size = CGSizeMake(181, 10);
    _progressView.centerX = self.width / 2;
    _progressView.top = _tipImageView.bottom + 8;
}

@end

@interface HTProfileBadgeController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//@property (nonatomic, strong) HTBadgeHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<HTBadge *> *badges;
@property (nonatomic, strong) HTProfileInfo *profileInfo;
@end

@implementation HTProfileBadgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.badges = [NSArray array];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"获得勋章";

    self.profileInfo = [[HTStorageManager sharedInstance] profileInfo];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.width, 160);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_collectionView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = [UIColor blackColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我的勋章";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    [_collectionView registerClass:[HTProfileBadgeCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([HTProfileBadgeCollectionCell class])];
    [_collectionView registerClass:[HTBadgeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:NSStringFromClass([HTBadgeHeaderView class])];
    
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getBadges:^(BOOL success, NSArray<HTBadge *> *badges) {
        [HTProgressHUD dismiss];
        if (success) {
            self.badges = badges;
            
            [_collectionView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"badgepage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"badgepage"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _collectionView.frame = CGRectMake(0, 60, self.view.width, self.view.height-60);
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.badges.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileBadgeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTProfileBadgeCollectionCell class]) forIndexPath:indexPath];
    HTBadge *badge = self.badges[indexPath.row];
    [cell setBadge:badge];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HTBadgeHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind  withReuseIdentifier:NSStringFromClass([HTBadgeHeaderView class]) forIndexPath:indexPath];
    NSInteger badgeLevel = [self badgeLevel];
    NSInteger targetLevel = [[[self badgeLevels] objectAtIndex:badgeLevel] integerValue];
    view.numberLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)badgeLevel+1];
    if ([self.profileInfo.gold integerValue] < 1200) {
        view.coinNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)(targetLevel - [self.profileInfo.gold integerValue])];
    }else{
        view.coinNumberLabel.text = @"0";
    }
    if (badgeLevel == 0) {
        CGFloat progress = 1 - (targetLevel - [self.profileInfo.gold integerValue]) / targetLevel;
        [view.progressView setProgress:progress];
    } else {
        CGFloat progress = 1 - (targetLevel - [self.profileInfo.gold integerValue]) / (targetLevel - [[[self badgeLevels] objectAtIndex:badgeLevel - 1] floatValue]);
        [view.progressView setProgress:progress];
    }
    return view;
}

- (NSInteger)badgeLevel {
    __block NSInteger badgeLevel = 0;
    [[self badgeLevels] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_profileInfo.gold integerValue] < [obj integerValue]) {
            badgeLevel = idx;
            *stop = YES;
        }
    }];
    return badgeLevel;
}

- (NSArray<NSNumber *> *)badgeLevels {
    return @[@20, @50, @100, @150, @250, @500, @800, @1000, @1200];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    HTDescriptionView *descriptionView = [[HTDescriptionView alloc] initWithURLString:nil andType:HTDescriptionTypeBadge];
    HTBadge *badge = self.badges[indexPath.row];
    if (badge.have) {
        [descriptionView setBadge:badge];
        [KEY_WINDOW addSubview:descriptionView];
        [descriptionView showAnimated];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cardLength = self.view.width / 2 - 20;
    return CGSizeMake(cardLength, cardLength);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(13, 13, 13, 13);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 14;
}

@end
