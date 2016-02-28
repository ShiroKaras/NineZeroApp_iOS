//
//  HTNotificationCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTNotificationCell.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>

static CGFloat kLineSpace = 7;

@interface HTNotificationCell ()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *separator;
@end

@implementation HTNotificationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_notification_mascot1"]];
        [self.contentView addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [HTMascotHelper colorWithMascotIndex:1];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.lineSpacing = kLineSpace;
        [self.contentView addSubview:_contentLabel];
        
        _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _separator.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [self.contentView addSubview:_separator];
    }
    return self;
}

- (void)setNotification:(HTNotification *)notification {
    _nameLabel.text = @"零仔NO.1";
    _nameLabel.textColor = [HTMascotHelper colorWithMascotIndex:1];
    [_nameLabel sizeToFit];
    _timeLabel.text = @"昨天";
    [_timeLabel sizeToFit];
    NSString *text = @"而QQ用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐QQ，他们把时代的机遇给了微信，但是把年轻人群再次给到了QQ。腾讯即通应用部的总经理张孝超说，使用手机QQ的用户，超过半成以上是90后和00后用户。这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，";
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    _contentLabel.size = rect.size;
    _contentLabel.text = text;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatar.frame = CGRectMake(24, 11, 35, 35);
    _nameLabel.centerY = _avatar.centerY;
    _nameLabel.left = _avatar.right + 8;
    _timeLabel.centerY = _nameLabel.centerY;
    _timeLabel.right = SCREEN_WIDTH - 27;
    _contentLabel.left = 27;
    _contentLabel.top = _avatar.bottom + 12;
    _separator.bottom = self.height - 1;
}

+ (CGFloat)calculateCellHeightWithText:(NSString *)text {
    text = @"而QQ用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐QQ，他们把时代的机遇给了微信，但是把年轻人群再次给到了QQ。腾讯即通应用部的总经理张孝超说，使用手机QQ的用户，超过半成以上是90后和00后用户。这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return 11 + 35 + 12 + 14 + rect.size.height;
}

@end
