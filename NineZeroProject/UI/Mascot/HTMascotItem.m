//
//  HTMascotItem.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/24.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotItem.h"
#import "YYImage.h"

static CGFloat kDurationPerAnimate = 0.033;

@implementation HTMascotItem
- (void)setIndex:(NSInteger)index {
    _index = index;
    NSArray<NSNumber *> *animatedCount = @[@113, @63, @52, @32, @74, @71, @105, @1];
    NSInteger count = [animatedCount[index] integerValue];
    NSMutableArray<UIImage *> *animatedImages = [NSMutableArray arrayWithCapacity:count];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        for (int i = 0; i != count; i++) {
//            NSString *imageName = [NSString stringWithFormat:@"img_mascot_%ld_animation_2_%05d", (index + 1), i];
//            YYImage *image = [YYImage imageNamed:imageName];
//            [animatedImages addObject:image];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.animationImages = animatedImages;
//            self.animationDuration = kDurationPerAnimate * count;
//            self.animationRepeatCount = 0;
//            [self startAnimating];
//        });
//    });
    for (int i = 0; i != count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_mascot_%ld_animation_2_%05d", (index + 1), i];
        YYImage *image = [YYImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        [animatedImages addObject:image];
    }
    self.animationImages = animatedImages;
    self.animationDuration = kDurationPerAnimate * count;
    self.animationRepeatCount = 0;
    [self startAnimating];
}
@end
