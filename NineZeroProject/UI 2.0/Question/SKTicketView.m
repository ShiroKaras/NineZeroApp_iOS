//
//  SKTicketView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKTicketView.h"
#import "HTUIHeader.h"

@implementation SKTicketView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 280, 108)]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *ticketBackgoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_couponbg"]];
    ticketBackgoundImageView.frame = self.frame;
    [self addSubview:ticketBackgoundImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_couponline"]];
    lineImageView.frame = self.frame;
    [self addSubview:lineImageView];
}

@end
