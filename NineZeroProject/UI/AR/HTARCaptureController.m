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

#define NUMBER_OF_POINTS    20

@interface HTARCaptureController () <PRARManagerDelegate>
@property (nonatomic, strong) PRARManager *prARManager;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *radarImageView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation HTARCaptureController

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
    
    // 1.AR
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
    
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
    self.radarImageView.animationDuration = 2.0f;
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
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(0, 0);
    [self.prARManager startARWithData:[self getDummyData] forLocation:locationCoordinates];
}

#pragma mark - Action

- (void)onClickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
- (NSArray*)getDummyData {
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    srand48(time(0));
    for (int i=0; i<NUMBER_OF_POINTS; i++) {
        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation];
        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
        [points addObject:point];
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation {
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates {
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"坐标%d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                           };
    return point;
}


#pragma mark - PRARManager Delegate

- (void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar {
    NSLog(@"Finished displaying ARObjects");
    
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
