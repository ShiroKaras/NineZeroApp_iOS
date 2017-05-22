//
//  NZBadgesView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/9.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZBadgesView.h"
#import "HTUIHeader.h"
#import "NZBadgeDetailView.h"

@interface NZBadgesView ()

@property (nonatomic, strong) NSArray<SKBadge *> *badgeArray;
@property (nonatomic, strong) NSArray<SKBadge *> *medalArray;
@property (nonatomic, assign) NSInteger exp;
@property (nonatomic, assign) NSInteger badgeLevel;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *titleImageView2;
@property (nonatomic, strong) NZBadgeDetailView *badgeDetailView;

@end

@implementation NZBadgesView

- (instancetype)initWithFrame:(CGRect)frame badges:(NSArray<SKBadge*>*)badges
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_puzzleachievement"]];
        [self addSubview:_titleImageView];
        _titleImageView.left = 16;
        _titleImageView.top = 16;
        
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserAchievement:^(BOOL success, NSInteger exp, NSInteger coopTime, NSArray<SKBadge *> *badges, NSArray<SKBadge*> *medals) {
        self.badgeArray = badges;
        self.medalArray = medals;
        
        _badgeLevel = 0;
        
        float width = (self.frame.size.width-16*4)/3;
        float height = width+32;
        
        //谜题成就
        for (int i=0; i<self.badgeArray.count +self.medalArray.count; i++) {
            if (i== self.badgeArray.count) {
                _titleImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_taskachievement"]];
                [self addSubview:_titleImageView2];
                _titleImageView2.left = 16;
                _titleImageView2.top = _viewHeight+16;
            }
            
            NZBadgeViewCell *cell;
            if (i<self.badgeArray.count) {
                cell = [[NZBadgeViewCell alloc] initWithFrame:CGRectMake(16+(16+width)*(i%3), _titleImageView.bottom+16+(14+height)*(i/3), width, height)];
                cell.tag = 100+i;
                [self addSubview:cell];
                [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:badges[i].medal_error_icon]];
                cell.nameLabel.text = badges[i].medal_name;
                if (exp >= [badges[i].medal_level integerValue]) {
                    _badgeLevel++;
                    [cell isGetBadge:YES];
                    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:badges[i].medal_icon]];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:cell.frame];
                button.tag = 300+i;
                [button addTarget:self action:@selector(didClickBadge:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            } else {
                unsigned long j = i-self.badgeArray.count;
                cell = [[NZBadgeViewCell alloc] initWithFrame:CGRectMake(16+(16+width)*(j%3), _titleImageView2.bottom+16+(14+height)*(j/3), width, height)];
                cell.tag = 200+j;
                [self addSubview:cell];
                [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:medals[j].medal_error_icon]];
                cell.nameLabel.text = medals[j].medal_name;
                if (coopTime >= [medals[j].medal_level integerValue]) {
                    _badgeLevel++;
                    [cell isGetBadge:YES];
                    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:medals[j].medal_icon]];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(16+(16+width)*(j%3), _titleImageView2.bottom+16+(14+height)*(j/3), width, height)];
                button.tag = 400+j;
                [button addTarget:self action:@selector(didClickMedal:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            
            _viewHeight = cell.bottom;
            
        }
        [self layoutIfNeeded];
        _viewHeight +=16;
        
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

#pragma mark - 

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)didClickBadge:(UIButton *)sender {
    _badgeDetailView = [[NZBadgeDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withBadge:_badgeArray[(int)sender.tag-300]];
    _badgeDetailView.userInteractionEnabled = YES;
    [[self viewController].view addSubview:_badgeDetailView];
}

- (void)didClickMedal:(UIButton *)sender {
    _badgeDetailView = [[NZBadgeDetailView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withBadge:_medalArray[(int)sender.tag-400]];
    _badgeDetailView.userInteractionEnabled = YES;
    [[self viewController].view addSubview:_badgeDetailView];
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
