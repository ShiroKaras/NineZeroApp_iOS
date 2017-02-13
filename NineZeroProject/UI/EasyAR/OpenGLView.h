/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol OpenGLViewDelegate <NSObject>

- (void)isRecognizedTarget;

@end

@interface OpenGLView : UIView

@property (nonatomic, strong) CAEAGLLayer *eaglLayer;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic) GLuint colorRenderBuffer;
@property (nonatomic, weak) id<OpenGLViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withSwipeType:(int)type targetsCount:(int)count;
- (void)start;
- (void)stop;
- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation;
- (void)setOrientation:(UIInterfaceOrientation)orientation;
- (void)startWithFileName:(NSString *)fileName videoURLs:(NSArray *)videoURLs;
- (void)setupProgressView:(NSProgress *)downloadProgress;

@end
