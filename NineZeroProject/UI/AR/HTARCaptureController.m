//
//  HTARCaptureController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/16.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTARCaptureController.h"
#include <stdlib.h>
#import <Masonry.h>
#import "CommonUI.h"
#import "INTULocationManager.h"
#import "MBProgressHUD+BWMExtension.h"
#import "HTUIHeader.h"
#import <UIImage+animatedGIF.h>
#import <AMapLocationKit/AMapLocationKit.h>

NSString *kTipCloseMascot = @"正在靠近藏匿零仔";
NSString *kTipTapMascotToCapture = @"快点击零仔进行捕获";

@interface HTARCaptureController () <PRARManagerDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) PRARManager *prARManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *mascotImageView;
@property (nonatomic, strong) HTImageView *captureSuccessImageView;
@property (nonatomic, strong) UIView *successBackgroundView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation HTARCaptureController {
    CLLocation *_currentLocation;
    CLLocationCoordinate2D _testMascotPoint;
    BOOL _needShowDebugLocation;
    UIView *_arView;
}

- (instancetype)initWithQuestion:(HTQuestion *)question {
    if (self = [super init]) {
        _question = question;
        
        if (_question.question_ar_location.length != 0) {
            NSDictionary *locationDict = [_question.question_ar_location dictionaryWithJsonString];
            if (locationDict && locationDict[@"lng"] && locationDict[@"lat"]) {
                double lat = [[NSString stringWithFormat:@"%@", locationDict[@"lat"]] doubleValue];
                double lng = [[NSString stringWithFormat:@"%@", locationDict[@"lng"]] doubleValue];
                DLog(@"lat=>%f \n lng=>%f", lat, lng);
                _testMascotPoint = CLLocationCoordinate2DMake(lat, lng);
            }
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        DLog(@"%@", location);
        if (!error) {
            DLog(@"cityCode = %@", regeocode.citycode);
        }
    }];

    _needShowDebugLocation = NO;
    
    // 1.AR
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:NO];
    
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
    self.radarImageView.layer.masksToBounds = YES;
    self.radarImageView.animationImages = radars;
    self.radarImageView.animationDuration = 2.0f;
    self.radarImageView.animationRepeatCount = 0;
    [self.radarImageView startAnimating];
    self.radarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShowDebug)];
    tapThree.numberOfTapsRequired = 1;
    [self.radarImageView addGestureRecognizer:tapThree];
    [self.view addSubview:self.radarImageView];
    
    // 4.提示
    self.tipImageView = [[UIImageView alloc] init];
    self.tipImageView.layer.masksToBounds = YES;
    self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
    self.tipImageView.contentMode = UIViewContentModeBottom;
    [self.tipImageView sizeToFit];
    [self.view addSubview:self.tipImageView];
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
    [self.tipImageView addSubview:self.tipLabel];
    [self showtipImageView];
    
    // 5.零仔
    NSMutableArray<UIImage *> *animatedImages = [NSMutableArray arrayWithCapacity:52];
    for (int i = 0; i != 52; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ar_mascot2_00%02d", i]];
        [animatedImages addObject:image];
    }
    self.mascotImageView = [[UIImageView alloc] init];
    self.mascotImageView.layer.masksToBounds = YES;
    UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:_question.question_ar_pet]];
    self.mascotImageView.image = gifImage;
    [self.mascotImageView startAnimating];
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
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {

}

- (void)showtipImageView {
    self.tipImageView.alpha = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hidetipImageView) userInfo:nil repeats:NO];
}

- (void)hidetipImageView {
    [UIView animateWithDuration:0.3 animations:^{
        self.tipImageView.alpha = 0;
    }];
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
        make.width.equalTo(@(288));
        make.height.equalTo(@(86));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipImageView);
        make.bottom.equalTo(self.tipImageView.mas_bottom).offset(-27);
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

#pragma mark - AMapDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    _currentLocation = location;
    [self.prARManager startARWithData:[self getDummyData] forLocation:location.coordinate];
}

#pragma mark - Action

- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCaptureMascotSuccessful {
    [self.delegate didClickBackButtonInARCaptureController:self];
}

- (void)onClickMascot {
    CGPoint currentLocation = CGPointMake(_currentLocation.coordinate.longitude, _currentLocation.coordinate.latitude);
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[[HTServiceManager sharedInstance] questionService] verifyQuestion:_question.questionID withLocation:currentLocation callback:^(BOOL success, HTResponsePackage *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (success && response.resultCode == 0) {
            self.rewardID = [response.data[@"reward_id"] integerValue];
            // 6.捕获成功
            self.successBackgroundView = [[UIView alloc] init];
            self.successBackgroundView.backgroundColor = [UIColor colorWithHex:0x1f1f1f alpha:0.8];
            self.successBackgroundView.layer.cornerRadius = 5.0f;
            [self.view addSubview:self.successBackgroundView];
            [self.view bringSubviewToFront:self.successBackgroundView];
            
            NSMutableArray<UIImage *> *images = [NSMutableArray array];
            for (int i = 0; i != 18; i++) {
                UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"img_ar_right_answer_gif_00%02d", i]];
                [images addObject:animatedImage];
            }
            self.captureSuccessImageView = [[HTImageView alloc] init];
            self.captureSuccessImageView.animationImages = images;
            self.captureSuccessImageView.animationDuration = 0.1 * 18;
            self.captureSuccessImageView.animationRepeatCount = 1;
            [self.successBackgroundView addSubview:self.captureSuccessImageView];
            [self.captureSuccessImageView startAnimating];
            
            [self.successBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(@161);
                make.width.equalTo(@173);
                make.height.equalTo(@173);
            }];
            
            [self.captureSuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@4);
                make.top.equalTo(@4);
                make.width.equalTo(@165);
                make.height.equalTo(@165);
            }];
            
            [self.mascotImageView removeFromSuperview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.1 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onCaptureMascotSuccessful];
            });
        } else {
           if (response.resultMsg) {
                [self showTipsWithText:response.resultMsg];
           } else {
                [self showTipsWithText:response.resultMsg];
           }
        }
    }];
}

- (void)onClickShowDebug {
    self.tipLabel.text = @"";
    _needShowDebugLocation = YES;
    [self showtipImageView];
    [self.view addSubview:_arView];
}

#pragma mark - Dummy AR Data

- (NSArray*)getDummyData {
    if (_testMascotPoint.latitude == 0 && _testMascotPoint.longitude == 0) {
        _testMascotPoint = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude + 0.0000001, _currentLocation.coordinate.longitude + 0.0000001);
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.mascotImageView];
        [self.view bringSubviewToFront:self.captureSuccessImageView];
    });
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    BOOL needShowMascot = YES;
    // x坐标匹配
    if (fabs(arViewFrame.origin.x) >= SCREEN_WIDTH && fabs(arViewFrame.origin.x - arViewFrame.size.width) >= SCREEN_WIDTH) {
        needShowMascot = NO;
    }
    // y坐标匹配
    if (fabs(arViewFrame.origin.y) >= SCREEN_HEIGHT / 2) {
        needShowMascot = NO;
    }
    CGFloat distance = self.prARManager.arObject.distance.floatValue;
    if (distance > 200){
        self.tipLabel.text = _question.hint;
        self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
        needShowMascot = NO;
    }else if(distance <= 200){
        self.tipLabel.text = kTipTapMascotToCapture;
        self.tipImageView.image = [UIImage imageNamed:@"img_ar_notification_bg_2"];
        needShowMascot = YES;
    }
    if (_needShowDebugLocation) {
        self.tipLabel.text = [NSString stringWithFormat:@"%.1f", distance];
    }
    self.mascotImageView.hidden = !needShowMascot;
    
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:problemTitle
                                                    message:problemDetails
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
