//
//  HTMascotItem.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/24.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotItem.h"
#import "YYImage.h"

static CGFloat kDurationPerAnimate = 0.1;

@implementation HTMascotItem {
    NSInteger animatedGuard;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        animatedGuard = 0;
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSString *imageName = [NSString stringWithFormat:@"img_mascot_%ld_animation_2_0000", (_index + 1)];
    YYImage *image = [YYImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    [self setImage:image];
}

- (void)playAnimatedNumber:(NSInteger)number {
    if (_index < 0 || _index > 7) return;
    if (number < 2 || number > 4) return;
    animatedGuard++;
    NSArray<NSNumber *> *animatedCount;
//    NSArray<NSNumber *> *animatedCount2 = @[@113, @63, @52, @32, @74, @71, @105, @1];
//    NSArray<NSNumber *> *animatedCount3 = @[@106, @75, @54, @22, @49, @79, @88, @1];
//    NSArray<NSNumber *> *animatedCount4 = @[@85, @77, @55, @38, @79, @89, @83, @1];

    NSArray<NSNumber *> *animatedCount2 = @[@38, @21, @17, @11, @25, @24, @35, @1];
    NSArray<NSNumber *> *animatedCount3 = @[@34, @25, @18, @7, @17, @26, @29, @1];
    NSArray<NSNumber *> *animatedCount4 = @[@28, @26, @17, @13, @26, @30, @28, @1];
    
    if (number == 2) animatedCount = animatedCount2;
    if (number == 3) animatedCount = animatedCount3;
    if (number == 4) animatedCount = animatedCount4;
    
    NSInteger count = [animatedCount[_index] integerValue];
    NSMutableArray<UIImage *> *animatedImages = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i != count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_mascot_%ld_animation_%ld_%04d", (_index + 1), (long)number , i];
        YYImage *image = [YYImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        [animatedImages addObject:image];
    }
    self.animationImages = animatedImages;
    self.animationDuration = kDurationPerAnimate * count;
    if (number == 3 || number == 4) {
        self.animationRepeatCount = 1;
        NSInteger tempAnimatedGuard = animatedGuard;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.animationDuration - 0.3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (tempAnimatedGuard == animatedGuard && self.animationImages != nil) {
                [self playAnimatedNumber:2];
            }
        });
    } else {
        self.animationRepeatCount = 0;
    }
    [self startAnimating];
}

- (void)stopAnyAnimation {
    self.animationImages = nil;
    [self stopAnimating];
    [self setIndex:_index];
}
@end
