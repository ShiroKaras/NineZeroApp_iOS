//
//  HTARCaptureController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/16.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "MotionEffectView.h"
#import "PRARManager.h"
#import <UIKit/UIKit.h>

@class SKQuestion;
@class SKReward;
@class SKStrongholdItem;
@class HTARCaptureController;
@protocol HTARCaptureControllerDelegate <NSObject>
- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller reward:(SKReward *)reward;
@end

@interface HTARCaptureController : UIViewController

- (instancetype)initWithQuestion:(SKQuestion *)question;
- (instancetype)initWithStronghold:(SKStrongholdItem*)stronghold;

@property (nonatomic, weak) id<HTARCaptureControllerDelegate> delegate;
@property (nonatomic, assign) NSString *rewardID;
@property (nonatomic, strong) SKQuestion *question;
@property (nonatomic, strong) NSString *pet_gif;
@property (nonatomic, assign) BOOL isHadReward;
@end
