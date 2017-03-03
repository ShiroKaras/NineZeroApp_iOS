
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
@property (nonatomic, strong) UIView    *chatBackView;
@property (nonatomic, strong) UIView    *chatColorBackView;
@property (nonatomic, strong) UILabel   *contentLabel;
@property (nonatomic, strong) UILabel   *stampLabel;
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
        
        _contentLabel = [UILabel new];
        _contentLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.numberOfLines = 0;
        [_chatBackView addSubview:_contentLabel];
        
        _stampLabel = [UILabel new];
        _stampLabel.font = PINGFANG_FONT_OF_SIZE(10);
        _stampLabel.textColor = [UIColor colorWithHex:0x9c9c9c];
        [_chatBackView addSubview:_stampLabel];
        
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [_chatBackView addSubview:_avatarImageView];
    }
    return self;
}

- (void)setObject:(SKChatObject*)object withType:(ChatFlowPositionType)type {
    _contentLabel.text = object.content;
    self.type = type;
    
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:PINGFANG_FONT_OF_SIZE(12),NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[object.content boundingRectWithSize:CGSizeMake(220,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    [self setTextHeight:actualsize.height cellFrame:self.frame];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[object.created_time longLongValue]];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    _stampLabel.text = confromTimespStr;
    [_stampLabel sizeToFit];
    
    [_stampLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(_chatColorBackView);
        } else if (type == ChatFlowPositionTypeRight) {
            make.right.equalTo(_chatColorBackView);
        }
    }];
}

- (void)setType:(ChatFlowPositionType)type {
    _type = type;
    
    
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:PINGFANG_FONT_OF_SIZE(12),NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[_contentLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,18) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    NSLog(@"%lf", actualsize.width);
    
    [_chatBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (actualsize.width>220) {
            make.width.equalTo(@248);
        } else {
            make.width.equalTo(@(actualsize.width+34));
            _contentLabel.textAlignment = NSTextAlignmentCenter;
        }
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(@14);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@14);
        } else if (type == ChatFlowPositionTypeRight) {
            make.right.equalTo(self).offset(-14);
        }
    }];
    
    //零仔头像
    [_avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(@0);
        if (type == ChatFlowPositionTypeLeft) {
            make.left.equalTo(@(0));
        } else if (type == ChatFlowPositionTypeRight) {
            make.left.equalTo(self.mas_right);
        }
    }];
    
    //气泡
    [_chatColorBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(4));
        make.right.equalTo(_chatBackView.mas_right);
        make.bottom.equalTo(@(-20));
        if (type == ChatFlowPositionTypeLeft) {
            make.top.equalTo(@(28.5));
        } else if (type == ChatFlowPositionTypeRight) {
            make.top.equalTo(@(0));
        }
    }];
    
    //背景色
    if (type == ChatFlowPositionTypeLeft) {
        _chatColorBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    } else if (type == ChatFlowPositionTypeRight) {
        _chatColorBackView.backgroundColor = COMMON_RED_COLOR;
    }
    
    //内容文本
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chatColorBackView).offset(14);
        make.right.equalTo(_chatColorBackView).offset(-14);
        if (type == ChatFlowPositionTypeLeft) {
            make.top.equalTo(@(28.5+14));
        } else if (type == ChatFlowPositionTypeRight) {
            make.top.equalTo(@(14));
        }
    }];
}

- (void)setTextWidth:(CGFloat)width {
    
}

- (void)setTextHeight:(CGFloat)height cellFrame:(CGRect)cellFrame {
    if (_type == ChatFlowPositionTypeLeft) {
        _cellHeight = height +28.5 +14 +14 +20 +14;
    } else {
        _cellHeight = height +28 +20 +14;
    }
    cellFrame.size.height = _cellHeight;
    [self setFrame:cellFrame];
}

@end
