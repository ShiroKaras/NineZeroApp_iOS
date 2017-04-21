//
//  NZLabTableViewCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabTableViewCell.h"
#import "HTUIHeader.h"

@interface NZLabTableViewCell ()
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation NZLabTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
    
        _cellHeight = 16+105+16+1;
        
        _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_article_list_cover_default"]];
        [self.contentView addSubview:_thumbImageView];
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140, 105));
            make.left.equalTo(@16);
            make.top.equalTo(@16);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"看完今年奥斯卡\n美国人问总统名字\n是不是也宣布错了";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        _titleLabel.numberOfLines = 0;
        [UILabel changeLineSpaceForLabel:_titleLabel WithSpace:3];
        [_titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_thumbImageView.mas_top).offset(9);
            make.left.equalTo(_thumbImageView.mas_right).offset(12);
            make.right.equalTo(self.mas_right).offset(-16);
        }];
        
        UIImageView *sayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_labpage_initiator"]];
        [self.contentView addSubview:sayImageView];
        [sayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.top.equalTo(_titleLabel.mas_bottom).offset(9);
        }];
        
    }
    
    return self;
}

@end
