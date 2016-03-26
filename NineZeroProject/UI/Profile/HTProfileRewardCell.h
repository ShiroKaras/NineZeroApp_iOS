//
//  HTProfileRewardCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat cardHeight;
@class HTTicket;
@interface HTProfileRewardCell : UITableViewCell
- (void)setReward:(HTTicket *)reward;
@end
