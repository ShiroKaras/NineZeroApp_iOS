//
//  HTImageView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTImageView.h"

@implementation HTImageView

- (void)setAnimatedImageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]]];
    self.animatedImage = image;
}

@end
