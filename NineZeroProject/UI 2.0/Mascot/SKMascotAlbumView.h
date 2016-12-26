//
//  SKMascotAlbumView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/26.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKPet;

@interface SKMascotAlbumView : UIView

- (instancetype)initWithFrame:(CGRect)frame withMascotArray:(NSArray<SKPet*>*)mascotArray;

@end
