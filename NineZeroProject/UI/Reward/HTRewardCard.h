//
//  HTTicketCard.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTicket;

@interface HTTicketCard : UIView
- (void)showExchangedCode:(BOOL)show;
- (void)setReward:(HTTicket *)reward;
@end
