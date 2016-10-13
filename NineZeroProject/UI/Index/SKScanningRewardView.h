//
//  SKScanningRewardViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTTicket;
@interface SKScanningRewardView : UIView

- (instancetype)initWithFrame:(CGRect)frame ticket:(HTTicket*)ticket;
- (instancetype)initWithFrame:(CGRect)frame rewardID:(NSString*)rewardID;

@end
