//
//  HTARCaptureController.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRARManager.h"

@class HTQuestion;
@class HTARCaptureController;
@protocol HTARCaptureControllerDelegate <NSObject>
- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller;
@end

@interface HTARCaptureController : UIViewController

- (instancetype)initWithQuestion:(HTQuestion *)question;
@property (nonatomic, weak) id<HTARCaptureControllerDelegate> delegate;

@end
