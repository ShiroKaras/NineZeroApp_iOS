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

#define NUMBER_OF_POINTS    20

const NSString *kTipCloseMascot = @"正在靠近藏匿零仔";
const NSString *kTipTapMascotToCapture = @"快点击零仔进行捕获";

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
    
    // 1.AR
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:NO];
    [[INTULocationManager sharedInstance] subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyBlock block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            _currentLocation = currentLocation;
            [self.prARManager startARWithData:[self getDummyData] forLocation:currentLocation.coordinate];
        }
    }];
    
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
    [self.view addSubview:self.radarImageView];
    
    // 4.提示
    self.tipImageView = [[UIImageView alloc] init];
    self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
    [self.view addSubview:self.tipImageView];
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = @"零仔藏在朝阳区繁华地带";
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
    [self.tipImageView addSubview:self.tipLabel];
    
    // 5.零仔
    self.mascotImageView = [[UIImageView alloc] init];
    self.mascotImageView.image = [UIImage imageNamed:@"img_mascot_4_animation_1"];
    [self.view addSubview:self.mascotImageView];
    
    [self buildConstrains];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
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
        make.centerY.equalTo(self.tipImageView).offset(4);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark - Action

- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Dummy AR Data

- (NSArray*)getDummyData {
    if (_testMascotPoint.latitude == 0 && _testMascotPoint.longitude == 0) {
        _testMascotPoint = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude + 0.01, _currentLocation.coordinate.longitude + 0.01);
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
    [self.view addSubview:arView];
//    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.radarImageView];
    [self.view bringSubviewToFront:self.tipImageView];
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails {
    [self alert:problemTitle withDetails:problemDetails];
}

@end
