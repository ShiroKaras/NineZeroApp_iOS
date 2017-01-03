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
@property (nonatomic, strong) UIView *backView;
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
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 20)];
        _backView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _backView.layer.cornerRadius = 5;
        [self.contentView addSubview:_backView];
        
        _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.lineSpacing = kLineSpace;
        [self.contentView addSubview:_contentLabel];
        
        _separator = [[UIView alloc] initWithFrame:CGRectMake(24, 0, SCREEN_WIDTH-48, 1)];
        _separator.backgroundColor = [UIColor colorWithHex:0x2d2d2d];
        [self.contentView addSubview:_separator];
        
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
    }
    return self;
}

- (void)setNotification:(SKNotification *)notification {
    _nameLabel.text = @"零仔〇";
    _nameLabel.textColor = [HTMascotHelper colorWithMascotIndex:1];
    [_nameLabel sizeToFit];
    if (notification.time != 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:notification.time];
        _timeLabel.text = [self stringWithDate:date];
        [_timeLabel sizeToFit];
    }else {
        _timeLabel.hidden = YES;
    }
    
    
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
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)[date hour], (long)[date minute]];
    } else if ([date isYesterday]) {
        return @"昨天";
    } else if ([date isInPast]) {
        return [NSString stringWithFormat:@"%04ld-%02ld-%02ld", (long)[date year], (long)[date month], (long)[date day]];
    }
    return @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentLabel.top = 24;
    _contentLabel.left = 24;
//    _contentLabel.right = self.right -24;
    _separator.bottom = _contentLabel.bottom+12;
    _avatar.top = _separator.bottom +12;
    _avatar.left = 24;
    _avatar.size = CGSizeMake(45, 45);
    _nameLabel.centerY = _avatar.centerY;
    _nameLabel.left = _avatar.right + 12;
    _timeLabel.centerY = _nameLabel.centerY;
    _timeLabel.right = SCREEN_WIDTH - 24;
    _backView.top = _contentLabel.top - 12;
    _backView.height = _contentLabel.height+12+12+1+12+45+12;
}

+ (CGFloat)calculateCellHeightWithText:(NSString *)text {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return 12+rect.size.height+12+1+12+45+12+12;
}

@end
