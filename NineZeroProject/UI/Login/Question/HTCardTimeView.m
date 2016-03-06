//
//  HTCardTimeView.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTCardTimeView.h"

@interface HTCardTimeView ()
@property (weak, nonatomic) IBOutlet UILabel *mainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *decoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@end

@implementation HTCardTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSString *className = NSStringFromClass([self class]);
        self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

@end
