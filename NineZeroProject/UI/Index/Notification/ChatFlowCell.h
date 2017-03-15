//
//  ChatFlowCell.h
//  ChatFlow
//
//  Created by SinLemon on 2017/2/17.
//  Copyright © 2017年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ChatFlowPositionTypeUnknow  = -1,
    ChatFlowPositionTypeRight    = 0,
    ChatFlowPositionTypeLeft   = 1
} ChatFlowPositionType;

@class SKChatObject;

@interface ChatFlowCell : UITableViewCell

@property (nonatomic, assign) ChatFlowPositionType type;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, assign) float cellHeight;

- (void)setObject:(SKChatObject*)object withType:(ChatFlowPositionType)type;

@end
