//
//  SKQuestionRankListView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionRankListView.h"
#import "HTUIHeader.h"

@interface SKQuestionRankListView ()
@property (nonatomic, strong) NSArray<SKUserInfo*>* rankerList;
@end

@implementation SKQuestionRankListView

- (instancetype)initWithFrame:(CGRect)frame rankerList:(NSArray<SKUserInfo*>*)rankerList withButton:(UIButton*)button
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rankerList = rankerList;
        [self createUIWithFrame:frame button:button];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame button:(UIButton*)button {
    UIView *rankBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, self.bottom-10)];
    rankBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rankBackView.layer.cornerRadius = 5;
    [self addSubview:rankBackView];
    
    UIImageView *rankImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_top_highlight"]];
    [self addSubview:rankImageView];
    rankImageView.frame = button.frame;
    
    UIScrollView *rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rankBackView.width, rankBackView.height)];
    float height = 21+ROUND_WIDTH_FLOAT(160)/160.*29.+22+ROUND_HEIGHT_FLOAT(114)+12+1+76*(self.rankerList.count-3)+20;
    rankScrollView.contentSize = CGSizeMake(rankBackView.width, height);
    [rankBackView addSubview:rankScrollView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chapter_leaderboard"]];
    [rankScrollView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(160));
        make.height.equalTo(@(ROUND_WIDTH_FLOAT(160)/160.*29.));
        make.top.equalTo(@21);
        make.centerX.equalTo(rankScrollView);
    }];
    
    // 1-3
    UIView *top13View = [UIView new];
    [rankScrollView addSubview:top13View];
    [top13View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImageView.mas_bottom).offset(22);
        make.width.equalTo(ROUND_WIDTH(268));
        make.height.equalTo(@114);
        make.centerX.equalTo(rankScrollView);
    }];
    
    // top1
    UIImageView *avatarImageView_top1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top1];
    [avatarImageView_top1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@72);
        make.height.equalTo(@72);
        make.centerX.equalTo(top13View);
        make.top.equalTo(top13View);
    }];
    
    UILabel *nameLabel_top1 = [UILabel new];
    if (self.rankerList.count>0)
        nameLabel_top1.text = self.rankerList[0].user_name;
    nameLabel_top1.textAlignment = NSTextAlignmentCenter;
    nameLabel_top1.textColor = [UIColor whiteColor];
    nameLabel_top1.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top1];
    [nameLabel_top1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top1);
        make.top.equalTo(avatarImageView_top1.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];
    
    // top2
    UIImageView *avatarImageView_top2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top2];
    [avatarImageView_top2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@56);
        make.top.equalTo(top13View).offset(16);
        make.centerX.equalTo(top13View.mas_left).offset(ROUND_WIDTH_FLOAT(268/6));
    }];
    
    UILabel *nameLabel_top2 = [UILabel new];
    if (self.rankerList.count>1)
        nameLabel_top2.text = self.rankerList[1].user_name;
    nameLabel_top2.textAlignment = NSTextAlignmentCenter;
    nameLabel_top2.textColor = [UIColor whiteColor];
    nameLabel_top2.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top2];
    [nameLabel_top2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top2);
        make.top.equalTo(avatarImageView_top2.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];
    
    // top3
    UIImageView *avatarImageView_top3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top3];
    [avatarImageView_top3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@56);
        make.top.equalTo(top13View).offset(16);
        make.centerX.equalTo(top13View.mas_right).offset(-ROUND_WIDTH_FLOAT(268/6));
    }];
    
    UILabel *nameLabel_top3 = [UILabel new];
    if (self.rankerList.count>2)
        nameLabel_top3.text = self.rankerList[2].user_name;
    nameLabel_top3.textAlignment = NSTextAlignmentCenter;
    nameLabel_top3.textColor = [UIColor whiteColor];
    nameLabel_top3.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top3];
    [nameLabel_top3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top3);
        make.top.equalTo(avatarImageView_top3.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x303030];
    [rankScrollView addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(top13View);
        make.height.equalTo(@1);
        make.top.equalTo(top13View.mas_bottom).offset(12);
        make.centerX.equalTo(top13View);
    }];
    
    // 4-10
    for (int i=0; i<self.rankerList.count-3; i++) {
        UIView *top410ViewCell = [UIView new];
        top410ViewCell.backgroundColor = [UIColor clearColor];
        [rankScrollView addSubview:top410ViewCell];
        [top410ViewCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ROUND_WIDTH(268));
            make.height.equalTo(@56);
            make.top.equalTo(splitLine.mas_bottom).offset(20+76*i);
            make.centerX.equalTo(rankScrollView);
        }];
        
        UILabel *orderLabel = [UILabel new];
        orderLabel.textColor = COMMON_RED_COLOR;
        orderLabel.text = [NSString stringWithFormat:@"%d", i+4];
        orderLabel.font = MOON_FONT_OF_SIZE(18);
        [orderLabel sizeToFit];
        [top410ViewCell addSubview:orderLabel];
        [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.centerY.equalTo(top410ViewCell);
        }];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.rankerList[i+3].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [top410ViewCell addSubview:avatarImageView];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@56);
            make.height.equalTo(@56);
            make.centerY.equalTo(top410ViewCell);
            make.centerX.equalTo(top410ViewCell.mas_centerX).offset(-22);
        }];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = self.rankerList[i+3].user_name;
        nameLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [nameLabel sizeToFit];
        [top410ViewCell addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatarImageView.mas_right).offset(16);
            make.centerY.equalTo(avatarImageView);
        }];
    }
}

@end
