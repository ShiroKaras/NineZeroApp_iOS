//
//  HTNotificationCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/29.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTNotificationCell.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>
#import "NSDate+TimeAgo.h"
#import "NSDate+Utility.h"

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
        _separator.backgroundColor = COMMON_SEPARATOR_COLOR;
        [self.contentView addSubview:_separator];
    }
    return self;
}

- (void)setNotification:(HTNotification *)notification {
    _nameLabel.text = @"零仔NO.1";
    _nameLabel.textColor = [HTMascotHelper colorWithMascotIndex:1];
    [_nameLabel sizeToFit];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:notification.time];
    _timeLabel.text = [self stringWithDate:date];
    [_timeLabel sizeToFit];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [notification.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    _contentLabel.size = rect.size;
    _contentLabel.text = notification.content;
    [self setNeedsLayout];
}

- (NSString *)stringWithDate:(NSDate *)date {
    if ([date isToday]) {
        return [NSString stringWithFormat:@"%02ld:%02ld", [date hour], [date minute]];
    } else if ([date isYesterday]) {
        return @"昨天";
    } else if ([date isLastYear]) {
        return @"1年前";
    } else if ([date isInPast]) {
        return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", [date year], [date month], [date day]];
    }
    return @"";
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
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return 11 + 35 + 12 + 14 + rect.size.height;
}

@end
