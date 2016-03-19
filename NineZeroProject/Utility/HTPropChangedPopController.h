//
//  HTPropChangedPopController.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTPropChangedPopController;
@protocol HTPropChangedPopControllerDelegate <NSObject>
- (void)onClickSureButtonInPopController:(HTPropChangedPopController *)controller;
@end

@class HTMascotProp;
@interface HTPropChangedPopController : NSObject
- (instancetype)initWithProp:(HTMascotProp *)prop;
- (void)show;
@property (nonatomic, weak) id<HTPropChangedPopControllerDelegate> delegate;
@end
