//
//  SKARRewardController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;
@class HTMascotProp;
@class HTTicket;

@interface SKARRewardController : UIViewController

- (instancetype)initWithRewardID:(uint64_t)rewardID questionID:(uint64_t)qid;

@end
