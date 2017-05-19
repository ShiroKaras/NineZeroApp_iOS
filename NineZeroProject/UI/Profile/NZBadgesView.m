//
//  NZBadgesView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/9.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZBadgesView.h"
#import "HTUIHeader.h"

@interface NZBadgesView ()

@property (nonatomic, strong) NSArray<SKBadge *> *badgeArray;
@property (nonatomic, strong) NSArray<SKBadge *> *medalArray;
@property (nonatomic, assign) NSInteger exp;
@property (nonatomic, assign) NSInteger badgeLevel;

@end

@implementation NZBadgesView

- (instancetype)initWithFrame:(CGRect)frame badges:(NSArray<SKBadge*>*)badges
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_puzzleachievement"]];
        [self addSubview:titleImageView];
        titleImageView.left = 16;
        titleImageView.top = 16;
        
        float width = (frame.size.width-16*4)/3;
        float height = width+32;
        //谜题成就
        for (int i=0; i<10; i++) {
            NZBadgeViewCell *cell = [[NZBadgeViewCell alloc] initWithFrame:CGRectMake(16+(16+width)*(i%3), titleImageView.bottom+16+(14+height)*(i/3), width, height)];
            cell.tag = 100+i;
            [self addSubview:cell];
            _viewHeight = cell.bottom;
        }
        
        UIImageView *titleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_taskachievement"]];
        [self addSubview:titleImageView2];
        titleImageView2.left = 16;
        titleImageView2.top = _viewHeight+16;
        //任务成就
        for (int i=0; i<7; i++) {
            NZBadgeViewCell *cell = [[NZBadgeViewCell alloc] initWithFrame:CGRectMake(16+(16+width)*(i%3), titleImageView2.bottom+16+(14+height)*(i/3), width, height)];
            cell.tag = 200+i;
            [self addSubview:cell];
            _viewHeight = cell.bottom;
        }
        _viewHeight +=16;
        
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserAchievement:^(BOOL success, NSInteger exp, NSInteger coopTime, NSArray<SKBadge *> *badges, NSArray<SKBadge*> *medals) {
        self.badgeArray = badges;
        self.medalArray = medals;
        
        _badgeLevel = 0;
        
        
        for (int i=0; i<badges.count; i++) {
            NZBadgeViewCell *cell = ((NZBadgeViewCell*)[self viewWithTag:100+i]);
            [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:badges[i].medal_error_icon]];
            cell.nameLabel.text = badges[i].medal_name;
            if (exp >= [badges[i].medal_level integerValue]) {
                _badgeLevel++;
                [cell isGetBadge:YES];
                [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:badges[i].medal_icon]];
            }
        }
        
        for (int i=0; i<medals.count; i++) {
            NZBadgeViewCell *cell = ((NZBadgeViewCell*)[self viewWithTag:200+i]);
            [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:medals[i].medal_error_icon]];
            cell.nameLabel.text = medals[i].medal_name;
            if (coopTime >= [medals[i].medal_level integerValue]) {
                _badgeLevel++;
                [cell isGetBadge:YES];
                [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:medals[i].medal_icon]];
            }
        }
    }];
}

- (NSInteger)badgeLevel {
    __block NSInteger badgeLevel = -1;
    DLog(@"%@", (NSArray *)[UD objectForKey:kBadgeLevels]);
    [[UD objectForKey:kBadgeLevels] enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSLog(@"Exp:%ld Target%ld", (long)self.exp, (long)[obj integerValue]);
        if (self.exp < [obj integerValue]) {
            badgeLevel = idx;
            *stop = YES;
        }
    }];
    return badgeLevel;
}

@end

@implementation NZBadgeViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.borderColor = COMMON_TITLE_BG_COLOR.CGColor;
        _coverImageView.layer.borderWidth = 1;
        [self addSubview:_coverImageView];
        
        _nameLabel = [UILabel new];
        _nameLabel.text = @"零仔勋章";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = COMMON_TEXT_3_COLOR;
        _nameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_nameLabel sizeToFit];
        [self addSubview:_nameLabel];
        _nameLabel.width = _coverImageView.width;
        _nameLabel.top = _coverImageView.bottom+14;
        _nameLabel.centerX = _coverImageView.centerX;
    }
    return self;
}

- (void)isGetBadge:(BOOL)flag {
    if (flag) {
        _coverImageView.layer.borderColor = COMMON_GREEN_COLOR.CGColor;
        _nameLabel.textColor = COMMON_GREEN_COLOR;
    } else {
        _coverImageView.layer.borderColor = COMMON_TITLE_BG_COLOR.CGColor;
        _nameLabel.textColor = COMMON_TEXT_3_COLOR;
    }
}

@end
