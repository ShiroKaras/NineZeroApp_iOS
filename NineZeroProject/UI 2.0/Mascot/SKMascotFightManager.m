//
//  SKMascotFightManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/1/4.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKMascotFightManager.h"

@implementation SKMascotFightManager

- (instancetype)initWithSize:(CGSize)frame {
    self = [super init];
    if (self) {
        frameSize = frame;
        [self startCamera];
    }
    return self;
}

- (void)dealloc {
    [cameraSession stopRunning];
    [refreshTimer invalidate];
}

- (void)startCamera
{
    cameraSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        NSError *error;
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (!error) {
            if ([cameraSession canAddInput:videoIn]) {
                [cameraSession addInput:videoIn];
            } else {
                NSLog(@"Couldn't add video input");
            }
        } else {
            NSLog(@"Couldn't create video input"); }
    } else {
        NSLog(@"Couldn't create video capture device");
    }
    
    cameraLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraSession];// autorelease];
    [cameraLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CGRect layerRect = CGRectMake(0, 0, frameSize.width, frameSize.height);
    [cameraLayer setBounds:layerRect];
    [cameraLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
}


#pragma mark - Refresh Of Overlay Positions

- (void)refreshPositionOfOverlay {

}

#pragma mark - Start fight

- (void)startFight {
    [cameraSession startRunning];
    [self.delegate setupMascotFightViewWithCameraLayer:cameraLayer];
    
    refreshTimer = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(refreshPositionOfOverlay)];
    [refreshTimer addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];

}

@end
