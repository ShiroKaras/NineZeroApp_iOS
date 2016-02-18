//
//  SharkfoodMuteSwitchDetector.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SharkfoodMuteSwitchDetectorBlock)(BOOL silent);

@interface SharkfoodMuteSwitchDetector : NSObject

+(SharkfoodMuteSwitchDetector*)shared;

@property (nonatomic,readonly) BOOL isMute;
@property (nonatomic,copy) SharkfoodMuteSwitchDetectorBlock silentNotify;

@end

typedef void(^SKMuteSwitchDetectorBlock)(BOOL success, BOOL silent);

@interface SKMuteSwitchDetector : NSObject

+ (void)checkSwitch:(SKMuteSwitchDetectorBlock)andPerform;

@end