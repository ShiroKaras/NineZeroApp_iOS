//
//  NZQuestionListCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionListCell.h"
#import "HTUIHeader.h"

@interface NZQuestionListCell()
@property (nonatomic, strong) UIImageView *questionTypeImageView;
@property (nonatomic, strong) UIImageView *questionCoverImageView;
@end

@implementation NZQuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _questionTypeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzlepage_timedtask"]];
        [self.contentView addSubview:_questionTypeImageView];
        [_questionTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        _questionCoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        _questionCoverImageView.layer.masksToBounds = YES;
        _questionCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_questionCoverImageView];
        [_questionCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_questionTypeImageView.mas_bottom).offset(20);
            make.left.equalTo(@16);
            make.right.equalTo(self).offset(-16);
            make.height.mas_equalTo((self.width-32)/288*162);
        }];
        
        [self layoutIfNeeded];
        self.cellHeight = _questionCoverImageView.bottom+20;
    }
    return self;
}

@end
