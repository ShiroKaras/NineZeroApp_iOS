//
//  HTPreviewQuestionController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/6.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTPreviewQuestionController;
@protocol HTPreviewQuestionControllerDelegate <NSObject>
- (void)previewController:(HTPreviewQuestionController *)previewController shouldShowGoBackItem:(BOOL)needShow;
@end

@interface HTPreviewQuestionController : UIViewController

/**
 *  @brief 回到今日
 */
- (void)goToToday;

@property (nonatomic, weak) id<HTPreviewQuestionControllerDelegate> delegate;

@end
