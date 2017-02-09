//
//  SKMascotFightManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/1/4.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol SKMascotFightManagerDelegate <NSObject>
- (void)setupMascotFightViewWithCameraLayer:(AVCaptureVideoPreviewLayer*)cameraLayer;
@end

@interface SKMascotFightManager : NSObject {
    //Camera
    AVCaptureSession *cameraSession;
    AVCaptureVideoPreviewLayer *cameraLayer;
    
    CGSize frameSize;
    CADisplayLink *refreshTimer;
}

@property(nonatomic, assign) id<SKMascotFightManagerDelegate> delegate;

- (instancetype)initWithSize:(CGSize)frame;
- (void)startFight;

@end
