
//  ChatFlowCell.m
//  ChatFlow
//
//  Created by SinLemon on 2017/2/17.
//  Copyright © 2017年 ShiroKaras. All rights reserved.
//

#import "ChatFlowCell.h"
#import "HTUIHeader.h"
#import <Masonry/Masonry.h>

@interface ChatFlowCell ()
@property (nonatomic, strong) UIView *chatBackView;
@property (nonatomic, strong) UIView *chatColorBackView;
@end

@implementation ChatFlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _chatBackView = [UIView new];
        _chatBackView.backgroundColor = [UIColor clearColor];
        [self addSubview:_chatBackView];
        
        _chatColorBackView = [UIView new];
        _chatColorBackView.backgroundColor = [UIColor redColor];
        _chatColorBackView.layer.cornerRadius = 5;
        [_chatBackView addSubview:_chatColorBackView];
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [_chatBackView addSubview:_avatarImageView];
    }
    return self;
}

- (void)setObject:(id)object withType:(ChatFlowPositionType)type {
    self.type = type;
    [self setTextHeight:100 cellFrame:self.frame];
}

- (void)setType:(ChatFlowPositionType)type {
    _type = type;
    [_chatBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(self.mas_height).offset(-20);
        make.top.equalTo(@10);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@14);
        } else if (type == ChatFlowPositionTypeRight) {
            make.right.equalTo(self).offset(-14);
        }
    }];
    
    [_avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(@0);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@(0));
        } else if (type == ChatFlowPositionTypeRight) {
            make.left.equalTo(self.mas_right);
        }
    }];
    
    if (type == ChatFlowPositionTypeLeft) {
        _chatColorBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    } else if (type == ChatFlowPositionTypeRight) {
        _chatColorBackView.backgroundColor = COMMON_RED_COLOR;
    }
    [_chatColorBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(4));
        make.right.equalTo(_chatBackView.mas_right);
        make.bottom.equalTo(@(-16));
        if (type == ChatFlowPositionTypeLeft) {
            make.top.equalTo(@(28.5));
        } else if (type == ChatFlowPositionTypeRight) {
            make.top.equalTo(@(0));
        }
    }];
    
}

- (void)setTextHeight:(CGFloat)height cellFrame:(CGRect)cellFrame {
    if (_type == ChatFlowPositionTypeLeft) {
        cellFrame.size.height = height +28.5 +14 +14 +16;
    } else {
        cellFrame.size.height = height +28 +16;
    }
    _cellHeight = cellFrame.size.height;
    [self setFrame:cellFrame];
}

@end
