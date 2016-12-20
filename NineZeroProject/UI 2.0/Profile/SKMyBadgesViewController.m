//
//  SKMyBadgesViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMyBadgesViewController.h"
#import "HTUIHeader.h"

#import "SKDescriptionView.h"

@interface SKBadgeCell: UICollectionViewCell
@property (nonatomic, strong) UIImageView *badgeLeft;
@property (nonatomic, strong) UIImageView *badgeRight;

@end

@implementation SKBadgeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COMMON_SEPARATOR_COLOR;
        
        UIView *headBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 6)];
        headBar.backgroundColor = [UIColor colorWithHex:0x242424];
        [self.contentView addSubview:headBar];
        
        UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, ROUND_HEIGHT_FLOAT(154)-4-25, self.width, 25)];
        footBar.backgroundColor = [UIColor colorWithHex:0x242424];
        [self.contentView addSubview:footBar];
        UIView *footBar2 = [[UIView alloc] initWithFrame:CGRectMake(0, ROUND_HEIGHT_FLOAT(154)-4, self.width, 4)];
        footBar2.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
        [self.contentView addSubview:footBar2];
        
        _badgeLeft = [[UIImageView alloc] init];
        _badgeLeft.contentMode = UIViewContentModeScaleAspectFill;
        _badgeLeft.layer.masksToBounds = YES;
        _badgeLeft.backgroundColor = [UIColor redColor];
        [self addSubview:_badgeLeft];
        [_badgeLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ROUND_WIDTH(120));
            make.height.mas_equalTo(ROUND_WIDTH_FLOAT(120)/120*90);
//            make.left.equalTo(ROUND_WIDTH(22));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-14);
        }];
    }
    return self;
}

@end



@interface SKMyBadgesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray<SKBadge*> *badgeArray;
@property (nonatomic, assign) NSInteger         exp;

@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) SKProfileProgressView *progressView;
@end

@implementation SKMyBadgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getBadges:^(BOOL success, NSInteger exp, NSArray<SKBadge *> *badges) {
        self.badgeArray = badges;
        self.exp = exp;
        
        NSMutableArray *badgeLevels = [NSMutableArray array];
        for (SKBadge *badge in badges) {
            [badgeLevels addObject:[NSNumber numberWithInteger:[badge.medal_level integerValue]]];
        }
        [UD setObject:[badgeLevels copy] forKey:kBadgeLevels];
        NSInteger badgeLevel = [self badgeLevel];
        if (badgeLevel == 0) {
            NSInteger targetLevel = [[[UD objectForKey:kBadgeLevels] objectAtIndex:badgeLevel] floatValue];
            _expLabel.text = [NSString stringWithFormat:@"%ld", (targetLevel-self.exp)];
            [_progressView setProgress:((float)self.exp)/(targetLevel-self.exp)];
        } else if (badgeLevel>0) {
            NSInteger targetLevel = [[[UD objectForKey:kBadgeLevels] objectAtIndex:badgeLevel] floatValue];
            _expLabel.text = [NSString stringWithFormat:@"%ld", (targetLevel-self.exp)];
            [_progressView setProgress:(self.exp-[[[UD objectForKey:kBadgeLevels] objectAtIndex:badgeLevel-1] floatValue])/(targetLevel-self.exp)];
        } else {
            _expLabel.text = @"0";
        }
        
        [self.collectionView reloadData];
    }];
}

- (void)createUI {
    WS(weakself);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *myBadgeTitleLabel = [UILabel new];
    myBadgeTitleLabel.text = @"我的勋章";
    myBadgeTitleLabel.textColor = [UIColor whiteColor];
    myBadgeTitleLabel.font = PINGFANG_FONT_OF_SIZE(20);
    [myBadgeTitleLabel sizeToFit];
    [self.view addSubview:myBadgeTitleLabel];
    
    UIImageView *nextBadgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exptext"]];
    [nextBadgeImageView sizeToFit];
    [self.view addSubview:nextBadgeImageView];
    
    UIImageView *expArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exp"]];
    [expArrowImageView sizeToFit];
    [self.view addSubview:expArrowImageView];
    
    _progressView = [[SKProfileProgressView alloc] initWithFrame:CGRectZero];
    [_progressView setProgress:0];
    [_progressView setBackColor:[UIColor colorWithHex:0x1f1f1f]];
    [_progressView setCoverColor:[UIColor colorWithHex:0xfdd900]];
    [self.view addSubview:_progressView];
    
    _expLabel = [UILabel new];
    _expLabel.text = @"0";
    _expLabel.textColor = [UIColor colorWithHex:0xffed41];
    _expLabel.font = MOON_FONT_OF_SIZE(12);
    [_expLabel sizeToFit];
    [self.view addSubview:_expLabel];
    
    [myBadgeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView);
        make.bottom.equalTo(nextBadgeImageView.mas_top).offset(-11);
        make.top.equalTo(@68);
    }];
    
    [nextBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressView).offset(10);
        make.bottom.equalTo(_progressView.mas_top).offset(-9);
    }];

    [expArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(nextBadgeImageView.mas_right).offset(2);
    }];
    
    [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(expArrowImageView.mas_right).offset(5);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.width.equalTo(@166);
        make.height.equalTo(@16);
    }];
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mymedal_medal"]];
    [badgeImageView sizeToFit];
    [self.view addSubview:badgeImageView];
    [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view);
        make.right.equalTo(weakself.view);
    }];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 162, SCREEN_WIDTH, SCREEN_HEIGHT-162) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SKBadgeCell class] forCellWithReuseIdentifier:NSStringFromClass([SKBadgeCell class])];
    [self.view addSubview:_collectionView];
}

- (NSInteger)badgeLevel {
    __block NSInteger badgeLevel = -1;
    DLog(@"%@", (NSArray*)[UD objectForKey:kBadgeLevels]);
    [[UD objectForKey:kBadgeLevels] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Exp:%ld Target%ld", (long)self.exp, (long)[obj integerValue]);
        if (self.exp  < [obj integerValue]) {
            badgeLevel = idx;
            *stop = YES;
        }
    }];
    return badgeLevel;
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKBadgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SKBadgeCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/2-5, ROUND_HEIGHT_FLOAT(154));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SKDescriptionView *descriptionView = [[SKDescriptionView alloc] initWithURLString:self.badgeArray[indexPath.row].medal_description andType:SKDescriptionTypeQuestion andImageUrl:self.badgeArray[indexPath.row].medal_pic];
    [self.view addSubview:descriptionView];
    [descriptionView showAnimated];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.self.badgeArray.count;
}

@end



@interface SKProfileProgressView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *coverColor;
@end

@implementation SKProfileProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithHex:0x232323];
        [self addSubview:_backView];
        
        _coverView = [[UIView alloc] init];
        [self addSubview:_coverView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsLayout];
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    _coverView.backgroundColor = coverColor;
}

- (void)setBackColor:(UIColor *)backColor {
    _backView.backgroundColor = backColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backView.layer.cornerRadius = 8.0f;
    _coverView.layer.cornerRadius = 8.0f;
    _backView.frame = CGRectMake(0, 0, self.width, self.height);
    _coverView.frame = CGRectMake(0, 0, self.width * MAX(0 ,MIN(_progress, 1)), self.height);
}

@end


