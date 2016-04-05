//
//  HTProfileRewardCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat cardHeight;
@class HTTicket;
@interface HTProfileRewardCell : UITableViewCell
- (void)setReward:(HTTicket *)reward;
@end
