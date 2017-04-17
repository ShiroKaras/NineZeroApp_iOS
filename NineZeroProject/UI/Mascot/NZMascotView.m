//
//  NZMascotView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZMascotView.h"
#import "HTUIHeader.h"

@interface NZMascotView ()
@property (nonatomic, strong) SKMascot *mascot;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation NZMascotView

- (instancetype)initWithFrame:(CGRect)frame withMascotIndex:(SKMascot*)mascot {
    self = [super initWithFrame:frame];
    if (self) {
        _mascot = mascot;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-49)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.image = [UIImage imageNamed:@"img_lingzaipage_bg"];
        [self addSubview:_backgroundImageView];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
        NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];      // 输出long long型
        NSLog(@"%@", curTime);
    }
    return self;
}

@end
