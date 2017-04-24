//
//  NZLabDetialCollectionViewCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabDetialCollectionViewCell.h"

@implementation NZLabDetialCollectionViewCell

#pragma mark - Accessors

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
