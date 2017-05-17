//
//  NZLabDetialCollectionViewCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabDetialCollectionViewCell.h"
#import "HTUIHeader.h"

@implementation NZLabDetialCollectionViewCell

#pragma mark - Accessors

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 2;
        self.layer.borderColor = COMMON_SEPARATOR_COLOR.CGColor;
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.commentLabel];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
        _avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 10;
    }
    return _avatarImageView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 9, self.frame.size.width-36, 16)];
        _usernameLabel.textColor = COMMON_TEXT_2_COLOR;
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(10);
    }
    return _usernameLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 36, self.frame.size.width-12, 16)];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (void)setComment:(NSString*)comment {
    _commentLabel.text = comment;
    [_commentLabel sizeToFit];
    _cellHeight = _commentLabel.height +42;
    NSLog(@"Comment label height: %lf", _cellHeight);
}

@end
