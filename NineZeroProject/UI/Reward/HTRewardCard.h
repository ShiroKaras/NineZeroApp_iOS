//
//  HTTicketCard.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTicket;

@interface HTTicketCard : UIView
- (void)showExchangedCode:(BOOL)show;
@property (nonatomic, strong) HTTicket *reward;
@end
