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

#import "MBProgressHUD+BWMExtension.h"
#import "HTUIHeader.h"
#import <UIImage+animatedGIF.h>
#import "SKHelperView.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

NSString *kTipCloseMascot = @"正在靠近藏匿零仔";
NSString *kTipTapMascotToCapture = @"快点击零仔进行捕获";

@interface HTARCaptureController () <PRARManagerDelegate,AMapLocationManagerDelegate,HTAlertViewDelegate>
@property (nonatomic, strong) PRARManager *prARManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *mascotImageView;
//@property (nonatomic, strong) MotionEffectView *mascotMotionView;
@property (nonatomic, strong) HTImageView *captureSuccessImageView;
@property (nonatomic, strong) UIView *successBackgroundView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationManager *singleLocationManager;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) SKHelperGuideView *guideView;
@property (nonatomic, strong) SKHelperScrollView *helpView;

@property (nonatomic, strong) NSArray *locationPointArray;
@end

@implementation HTARCaptureController {
    CLLocation *_currentLocation;
    CLLocationCoordinate2D _testMascotPoint;
    BOOL _needShowDebugLocation;
    UIView *_arView;
    BOOL startFlag;
}

- (instancetype)initWithQuestion:(SKQuestion *)question {
    if (self = [super init]) {
        _question = question;
        startFlag = false;
        self.locationPointArray = question.question_location;
        if (_question.question_location.count > 0) {
            for (NSDictionary *locationDict in _question.question_location) {
                double lat = [[NSString stringWithFormat:@"%@", locationDict[@"lat"]] doubleValue];
                double lng = [[NSString stringWithFormat:@"%@", locationDict[@"lng"]] doubleValue];
                DLog(@"lat=>%f \n lng=>%f", lat, lng);
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self registerLocation];

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
    
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
    NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:self.question.question_ar_pet];
    NSString *unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [self.question.question_ar_pet stringByDeletingPathExtension]]];
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:unzipFilesPath];
    //列举目录内容，可以遍历子目录
    NSString *unzipFileName;
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    while((unzipFileName=[myDirectoryEnumerator nextObject])!=nil) {
        NSData * data = [NSData dataWithContentsOfFile:[unzipFilesPath stringByAppendingPathComponent:unzipFileName]];
        UIImage *image = [UIImage imageWithData:data];
        [images addObject:image];
    }
    self.mascotImageView = [[UIImageView alloc] init];
    self.mascotImageView.layer.masksToBounds = YES;
    self.mascotImageView.hidden = YES;
    self.mascotImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.mascotImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMascot)];
    [self.mascotImageView addGestureRecognizer:tap];
    self.mascotImageView.animationImages = images;
    self.mascotImageView.animationDuration = 0.1 * images.count;
    self.mascotImageView.animationRepeatCount = 0;
    [self.mascotImageView startAnimating];

    
//    self.mascotMotionView = [[MotionEffectView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    self.mascotMotionView.hidden = YES;
//    self.mascotMotionView.imageView.hidden = YES;
//    self.mascotMotionView.center = self.view.center;
//    self.mascotMotionView.delegate = self;
//    [self.view addSubview:self.mascotMotionView];
//    [self.mascotMotionView setImage:self.mascotImageView];
    
    if (FIRST_LAUNCH_AR) {
        SKHelperScrollView *helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeAR];
        helpView.scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT-356)/2, 0, 0);
        helpView.dimmingView.alpha = 0;
        [KEY_WINDOW addSubview:helpView];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            helpView.dimmingView.alpha = 0.9;
        } completion:^(BOOL finished) {
            
        }];
        [UD setBool:YES forKey:@"firstLaunchTypeAR"];
    }
    
    [self buildConstrains];
    
    //判断GPS是否开启
    HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
    alertView.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
        }else {
            [alertView show];
        }
    }else {
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.prARManager stopAR];
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc {

}

- (void)didClickOKButton {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        make.centerY.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width);
    }];
    
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)showGuideviewWithType:(SKHelperGuideViewType)type {
    _guideView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:type];
    [KEY_WINDOW addSubview:_guideView];
    [KEY_WINDOW bringSubviewToFront:_guideView];
}

#pragma mark - Location

- (void)registerLocation {
    self.singleLocationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.singleLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.singleLocationManager.locationTimeout = 2;
    //   逆地理请求超时时间，可修改，最小2s
    self.singleLocationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）
    [self.singleLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        _testMascotPoint = [self getCurrentLocationWith:location];
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];

    }];
}

- (CLLocationCoordinate2D)getCurrentLocationWith:(CLLocation *)location {
    CLLocationDistance currentDistance = -1;
    CLLocationCoordinate2D currentPoint = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    for (NSDictionary *dict in _question.question_location) {
        double lat = [dict[@"lat"] doubleValue];
        double lng = [dict[@"lng"] doubleValue];
        
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        if (currentDistance < 0 || distance < currentDistance) {
            currentDistance = distance;
            currentPoint = CLLocationCoordinate2DMake(lat, lng);
        }
    }
    startFlag = true;
    return currentPoint;
}

//#pragma MotionEffectViewDelegate
//
//- (void)didTapMotionEffectView:(MotionEffectView *)view {
//    [self onClickMascot];
//}

#pragma mark - AMapDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (startFlag) {
        _currentLocation = location;
        [self.prARManager startARWithData:[self getDummyData] forLocation:location.coordinate];        
    }
}

#pragma mark - Action

- (void)arQuestionHelpButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"vrtips"];
    _helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeAR];
    _helpView.scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT-356)/2, 0, 0);
    _helpView.dimmingView.alpha = 0;
    [self.view addSubview:_helpView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _helpView.dimmingView.alpha = 0.9;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)onClickBack {
//    [self.mascotMotionView disableMotionEffect];
//    [self.mascotMotionView removeFromSuperview];
//    self.mascotMotionView = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCaptureMascotSuccessfulWithReward:(SKReward *)reward {
    [self.delegate didClickBackButtonInARCaptureController:self reward:reward];
}

- (void)onClickMascot {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[[SKServiceManager sharedInstance] answerService] answerLBSQuestionWithLocation:_currentLocation callback:^(BOOL success, SKResponsePackage *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (success && response.result == 0) {
            self.rewardID = response.data[@"reward_id"];
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
            self.captureSuccessImageView.animationDuration = 0.05 * 18;
            self.captureSuccessImageView.animationRepeatCount = 1;
            [self.successBackgroundView addSubview:self.captureSuccessImageView];
            [self.captureSuccessImageView startAnimating];
            
            [self.successBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.centerY.equalTo(self.view).offset(-30);
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
//            [self.mascotMotionView removeFromSuperview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.05 * 18) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onCaptureMascotSuccessfulWithReward:[SKReward objectWithKeyValues:[response.data keyValues]]];
            });
        } else {
            if (response.result) {
                [self showTipsWithText:[NSString stringWithFormat:@"异常%ld", (long)response.result]];
            } else {
                [self showTipsWithText:@"异常"];
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
    [self.view bringSubviewToFront:self.helpButton];
    [self.view bringSubviewToFront:self.helpView];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.view bringSubviewToFront:self.mascotMotionView];
        [self.view bringSubviewToFront:self.mascotImageView];
        [self.view bringSubviewToFront:self.captureSuccessImageView];
    });
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    BOOL needShowMascot = NO;
    // x坐标匹配
    if (fabs(arViewFrame.origin.x) >= SCREEN_WIDTH && fabs(arViewFrame.origin.x - arViewFrame.size.width) >= SCREEN_WIDTH) {
        needShowMascot = NO;
    }
    // y坐标匹配
    if (fabs(arViewFrame.origin.y) >= SCREEN_HEIGHT / 2) {
        needShowMascot = NO;
    }
    CGFloat distance = self.prARManager.arObject.distance.floatValue;
    if (distance > 500){
        self.tipLabel.text = _question.hint;
        self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
        needShowMascot = NO;
    } else if  (distance > 200) {
        self.tipLabel.text = kTipCloseMascot;
        self.tipImageView.image = [UIImage imageNamed:@"img_ar_notification_bg_1"];
        needShowMascot = NO;
    } else if(distance > 0){
        self.tipLabel.text = kTipTapMascotToCapture;
        self.tipImageView.image = [UIImage imageNamed:@"img_ar_notification_bg_2"];
        needShowMascot = YES;
//        [self.mascotMotionView enableMotionEffect];
    }
    if (_needShowDebugLocation) {
        self.tipLabel.text = [NSString stringWithFormat:@"%.1f", distance];
    }
//    self.mascotMotionView.hidden = !needShowMascot;
//    self.mascotMotionView.imageView.hidden = !needShowMascot;
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
