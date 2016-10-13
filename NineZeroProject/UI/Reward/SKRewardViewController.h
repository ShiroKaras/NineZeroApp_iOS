//
//  SKRewardViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKRewardViewController : UIViewController

- (instancetype)initWithQuestionRewardID:(uint64_t)rewardID questionID:(uint64_t)qid;
- (instancetype)initWithScanningRewardID:(NSString*)rewardID;

@end
