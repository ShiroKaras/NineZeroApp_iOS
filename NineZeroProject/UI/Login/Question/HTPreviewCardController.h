//
//  HTPreviewCardController.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HTPreviewCardTypeDefault,
    HTPreviewCardTypeRecord,
    HTPreviewCardTypeUnknown,
} HTPreviewCardType;

@class  HTPreviewCardController;
@protocol HTPreviewCardControllerDelegate <NSObject>
@optional;
- (void)didClickCloseButtonInController:(HTPreviewCardController *)controller;
@end

@class HTQuestion;
@interface HTPreviewCardController : UIViewController
- (instancetype)initWithType:(HTPreviewCardType)type;
- (instancetype)initWithType:(HTPreviewCardType)type andQuestList:(NSArray<HTQuestion *> *)questions;
- (void)backToToday;

@property (nonatomic, weak) id<HTPreviewCardControllerDelegate> delegate;

@end
