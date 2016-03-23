//
//  HTProfileRecordCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileRecordCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"

@interface HTProfileRecordCell ()
@property (strong, nonatomic) UIView *playItemBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *coverImageView;
@end

@implementation HTProfileRecordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _playItemBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _playItemBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _playItemBackView.layer.cornerRadius = 5.0f;
        [self addSubview:_playItemBackView];
        
        _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        [_playItemBackView addSubview:_coverImageView];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_success_record_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_success_record_play_highlight"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(onClickPlayButton) forControlEvents:UIControlEventTouchUpInside];
        [_playItemBackView addSubview:_playButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playItemBackView.frame = self.bounds;
    _coverImageView.frame = CGRectMake(4, 4, self.width - 8, self.height - 8);
    _playButton.size = CGSizeMake(57, 57);
    _playButton.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)onClickPlayButton {
    [self.delegate onClickedPlayButtonInCollectionCell:self];
}

@end
