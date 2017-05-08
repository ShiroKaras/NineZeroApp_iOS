//
//  NZTicketListView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/4.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZTicketListView.h"
#import "HTUIHeader.h"

#import "SKTicketView.h"

#define TICKET_NUM 5

@interface NZTicketListView ()
@property (nonatomic, strong) NSArray<SKTicket*> *ticketsArray;
@end

@implementation NZTicketListView

- (instancetype)initWithFrame:(CGRect)frame withTickets:(NSArray<SKTicket *> *)tickets
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_gift"]];
        [self addSubview:titleImageView];
        titleImageView.left = 16;
        titleImageView.top = 16;
        
        for (int i=0; i<TICKET_NUM; i++) {
            SKTicketView *ticketView = [[SKTicketView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+16+i*((self.width-32)/288*111+6), self.width-32, (self.width-32)/288*111) reward:nil];
            [self addSubview:ticketView];
        }
    
        self.viewHeight = titleImageView.bottom+16+ ((self.width-32)/288*111+6)*(TICKET_NUM+1)+36;
        self.height = _viewHeight;
    }
    return self;
}

@end
