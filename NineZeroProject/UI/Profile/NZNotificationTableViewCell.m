//
//  NZNotificationTableViewCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZNotificationTableViewCell.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>
#import "NSDate+TimeAgo.h"
#import "NSDate+Utility.h"

static CGFloat kLineSpace = 7;

@interface NZNotificationTableViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation NZNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 40, 40)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"img_profile_photo_default"];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 16, 200, 18)];
        _nameLabel.textColor = COMMON_TEXT_2_COLOR;
        _nameLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _nameLabel.text = @"零仔〇";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right+16, 18, 100, 16)];
        _timeLabel.text = @"很久以前";
        _timeLabel.textColor = COMMON_TEXT_3_COLOR;
        _timeLabel.font = PINGFANG_FONT_OF_SIZE(10);
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, _nameLabel.bottom+16, self.width-72-16-16, 100)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    }
    return _bottomLine;
}

- (void)setNotification:(SKNotification *)notification {
    _nameLabel.text = @"零仔〇";
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
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:12],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [notification.content boundingRectWithSize:CGSizeMake(self.width - 72-16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    _contentLabel.size = rect.size;
    _contentLabel.text = notification.content;
    [self setNeedsLayout];
    
    _cellHeight = _contentLabel.bottom+17;
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

+ (CGFloat)calculateCellHeightWithText:(NSString *)text {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = kLineSpace;
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                             NSParagraphStyleAttributeName : style};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 54, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return 16+18+16+rect.size.height+16+1;
}

@end
