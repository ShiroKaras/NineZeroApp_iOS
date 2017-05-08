//
//  NZTicketListView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/4.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKTicket;

@interface NZTicketListView : UIView
@property (nonatomic, assign) float viewHeight;

- (instancetype)initWithFrame:(CGRect)frame withTickets:(NSArray<SKTicket*>*)tickets;

@end
