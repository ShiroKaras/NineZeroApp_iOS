//
//  HTARCaptureController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTARCaptureController.h"
#include <stdlib.h>
#import <Masonry.h>
#import "CommonUI.h"
#import "INTULocationManager.h"
#import "MBProgressHUD+BWMExtension.h"
#import "HTUIHeader.h"

#define NUMBER_OF_POINTS    20

NSString *kTipMascotLocation = @"零仔藏在朝阳区繁华地带";
NSString *kTipCloseMascot = @"正在靠近藏匿零仔";
NSString *kTipTapMascotToCapture = @"快点击零仔进行捕获";

@interface HTARCaptureController () <PRARManagerDelegate>
@property (nonatomic, strong) PRARManager *prARManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *mascotImageView;
@end

@implementation HTARCaptureController {
    CLLocation *_currentLocation;
    CLLocationCoordinate2D _testMascotPoint;
    INTULocationRequestID _locationId;
    BOOL _needShowDebugLocation;
    UIView *_arView;
}

- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // for test
    _testMascotPoint = CLLocationCoordinate2DMake(0, 0);
    _needShowDebugLocation = NO;
    
    // 1.AR
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:NO];
    _locationId = [[INTULocationManager sharedInstance] subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyBlock block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            _currentLocation = currentLocation;
            [self.prARManager startARWithData:[self getDummyData] forLocation:currentLocation.coordinate];
        }
    }];
    
//    _locationId = [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//        if (status == INTULocationStatusSuccess) {
//            _currentLocation = currentLocation;
//            [self.prARManager startARWithData:[self getDummyData] forLocation:currentLocation.coordinate];
//        }
//    }];
    
    // 2.返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back_highlight"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    [self.view addSubview:self.backButton];

    // 3.雷达
    NSInteger radarCount = 50;
    NSMutableArray *radars = [NSMutableArray arrayWithCapacity:radarCount];
    for (int i = 0; i != radarCount; i++) {
        [radars addObject:[UIImage imageNamed:[NSString stringWithFormat:@"raw_radar_gif_000%02d", i]]];
    }
    self.radarImageView = [[UIImageView alloc] init];
    self.radarImageView.animationImages = radars;
    self.radarImageView.animationDuration = 1.0f;
    self.radarImageView.animationRepeatCount = 0;
    [self.radarImageView startAnimating];
    self.radarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShowDebug)];
    tapThree.numberOfTapsRequired = 3;
    [self.radarImageView addGestureRecognizer:tapThree];
    [self.view addSubview:self.radarImageView];
    
    // 4.提示
    self.tipImageView = [[UIImageView alloc] init];
    self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
    [self.view addSubview:self.tipImageView];
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = kTipMascotLocation;
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
    [self.tipImageView addSubview:self.tipLabel];
    
    // 5.零仔
    self.mascotImageView = [[UIImageView alloc] init];
    self.mascotImageView.image = [UIImage imageNamed:@"img_mascot_4_animation_1"];
    self.mascotImageView.hidden = YES;
    self.mascotImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.mascotImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMascot)];
    [self.mascotImageView addGestureRecognizer:tap];
    [self buildConstrains];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.prARManager stopAR];
    [[INTULocationManager sharedInstance] cancelLocationRequest:_locationId];
}

- (void)dealloc {

}

- (void)buildConstrains {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@11);
        make.bottom.equalTo(@(-11));
    }];
    
    [self.radarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@11);
        make.right.equalTo(@(-11));
        make.width.equalTo(@(90));
        make.height.equalTo(@(90));
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-55));
        make.centerX.equalTo(self.view);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipImageView);
        make.centerY.equalTo(self.tipImageView).offset(3);
    }];
    
    [self.mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@130);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@265);
        make.height.equalTo(@265);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark - Action

- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickMascot {
    [MBProgressHUD bwm_showTitle:@"捕获到零仔!" toView:[[[UIApplication sharedApplication] delegate] window] hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
    self.mascotImageView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self onClickBack];
    });
}

- (void)onClickShowDebug {
    _needShowDebugLocation = YES;
    [self.view addSubview:_arView];
}

#pragma mark - Dummy AR Data

- (NSArray*)getDummyData {
    if (_testMascotPoint.latitude == 0 && _testMascotPoint.longitude == 0) {
        _testMascotPoint = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude + 0.005, _currentLocation.coordinate.longitude + 0.005);
    }
    NSDictionary *point = [self createPointWithId:0 at:_testMascotPoint];
    return @[point];
}

- (NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates {
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"坐标%d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                           };
    return point;
}


#pragma mark - PRARManager Delegate

- (void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer {
    [self.view.layer addSublayer:cameraLayer];
    if (_needShowDebugLocation) {
        [self.view addSubview:arView];
    }
    _arView = arView;
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.radarImageView];
    [self.view bringSubviewToFront:self.tipImageView];
    [self.view bringSubviewToFront:self.mascotImageView];
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    BOOL needShowMascot = YES;
    // x坐标匹配
    if (fabs(arViewFrame.origin.x) >= SCREEN_WIDTH && fabs(arViewFrame.origin.x - arViewFrame.size.width) >= SCREEN_WIDTH) needShowMascot = NO;
    // y坐标匹配
    if (fabs(arViewFrame.origin.y) >= SCREEN_HEIGHT / 2) needShowMascot = NO;
    
    CGFloat distance = self.prARManager.arObject.distance.floatValue;
    if (distance >= 500) {
        self.tipLabel.text = kTipMascotLocation;
        needShowMascot = NO;
    } else if (distance >= 300 && distance < 500) {
        self.tipLabel.text = kTipCloseMascot;
        needShowMascot = NO;
    } else if (distance < 300) {
        self.tipLabel.text = kTipTapMascotToCapture;
    }
    if (_needShowDebugLocation) {
        self.tipLabel.text = [self.tipLabel.text stringByAppendingFormat:@"(%.1f)", distance];
    }
    self.mascotImageView.hidden = !needShowMascot;
    
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails {
    [self alert:problemTitle withDetails:problemDetails];
}

@end
