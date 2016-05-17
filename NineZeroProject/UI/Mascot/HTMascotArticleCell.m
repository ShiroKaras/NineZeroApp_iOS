//
//  HTMascotArticleCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotArticleCell.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>

@interface HTMascotArticleCell ()
@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) TTTAttributedLabel *title;
@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UIImageView *tipIcon;
@end

@implementation HTMascotArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        _cover = [[UIImageView alloc] init];
        [self.contentView addSubview:_cover];
        
        _title = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont systemFontOfSize:15];
        _title.numberOfLines = 2;
        _title.lineSpacing = 3;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_title];
        
        _number = [[UILabel alloc] init];
        _number.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_number];
        
        _tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_article_list_new"]];
        [_cover addSubview:_tipIcon];
    }
    return self;
}

- (void)setArticle:(HTArticle *)article {
    _article = article;
    
    _title.text = article.articleTitle;
    _number.textColor = [HTMascotHelper colorWithMascotIndex:article.mascotID];
    
    NSArray *mascotNameArray = @[@"零仔〇", @"零仔Sloth·S", @"零仔Pride·W", @"零仔Wrath·C", @"零仔Envy·I", @"零仔Lust·B", @"零仔Gluttony·T", @"零仔Greed·F"];
    _number.text = [NSString stringWithFormat:@"/ %@",mascotNameArray[article.mascotID-1]];
    _tipIcon.hidden = article.hasRead;
    [_cover sd_setImageWithURL:[NSURL URLWithString:article.article_pic_1] placeholderImage:[UIImage imageNamed:@"test_imaga"]];
    _cover.layer.masksToBounds = YES;
    _cover.contentMode = UIViewContentModeScaleAspectFill;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@7.5);
        make.width.equalTo(@130);
        make.height.equalTo(@95);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cover.mas_top).offset(19);
        make.left.equalTo(_cover.mas_right).offset(15);
    }];
    
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_left);
        make.top.equalTo(_title.mas_bottom).offset(12);
    }];
    
    [_tipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@-2);
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [self setNeedsUpdateConstraints];
    [super layoutSubviews];
    [_title setPreferredMaxLayoutWidth:SCREEN_WIDTH - 12 - 130 - 15 - 28];
}

@end
