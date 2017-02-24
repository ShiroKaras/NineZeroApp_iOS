//
//  ChatFlowCell.m
//  ChatFlow
//
//  Created by SinLemon on 2017/2/17.
//  Copyright © 2017年 ShiroKaras. All rights reserved.
//

#import "ChatFlowCell.h"
#import <Masonry/Masonry.h>

@interface ChatFlowCell ()
@property (nonatomic, strong) UIView *chatBackView;
@end

@implementation ChatFlowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _chatBackView = [UIView new];
        _chatBackView.layer.cornerRadius = 5;
        _chatBackView.backgroundColor = [UIColor redColor];
        [self addSubview:_chatBackView];
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
    }
    return self;
}

- (void)setType:(ChatFlowPositionType)type {
    [_chatBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height).offset(-20);
        make.top.equalTo(@10);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@60);
        } else if (type == ChatFlowPositionTypeRight) {
            make.right.equalTo(self).offset(-60);
        }
    }];
    
    [_avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(@10);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@(10));
        } else if (type == ChatFlowPositionTypeRight) {
            make.right.equalTo(self).offset(-10);
        }
    }];
}

@end
