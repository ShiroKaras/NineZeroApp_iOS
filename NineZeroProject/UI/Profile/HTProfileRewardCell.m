//
//  HTProfileRewardCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileRewardCell.h"
#import "HTUIHeader.h"
#import "HTRewardCard.h"

CGFloat cardHeight = 143;

@interface HTProfileRewardCell ()
@property (nonatomic, strong) HTRewardCard *card;
@end

@implementation HTProfileRewardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _card = [[HTRewardCard alloc] initWithFrame:CGRectZero];
        [_card showExchangedCode:NO];
        [self.contentView addSubview:_card];
    }
    return self;
}

- (void)setReward:(HTReward *)reward {
    [_card setReward:reward];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _card.top = 21;
    _card.centerX = self.width / 2;
    _card.height = cardHeight;
}

@end
