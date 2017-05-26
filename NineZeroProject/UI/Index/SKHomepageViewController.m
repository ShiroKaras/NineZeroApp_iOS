//
//  SKHomepageViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKHomepageViewController.h"
#import "HTUIHeader.h"

#import "JPUSHService.h"
#import "SKSwipeViewController.h"
#import "NZTaskViewController.h"
#import "SKSwipeViewController.h"
#import "HTARCaptureController.h"
#import "NZAdView.h"
#import "SKActivityNotificationView.h"
#import "HTWebController.h"
#import "NZQuestionGiftView.h"

#import "NZPScanningFileDownloadManager.h"
#import "SSZipArchive.h"

@interface SKHomepageViewController () <HTARCaptureControllerDelegate>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) SKIndexScanning *scaningInfo;
@property (nonatomic, strong) SKActivityNotificationView *activityNotificationView; //活动通知
@property (nonatomic, strong) NSString *adLink;

@property (nonatomic, strong) UIButton  *changeCityButton;
@property (nonatomic, assign) NSInteger selectedCityIndex;
@property (nonatomic, strong) NSString  *selectedCityCode;
@end

@implementation SKHomepageViewController {
    UIButton *_selectedButton;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    _selectedCityCode = @"010";
    [self createUI];
    [[[SKServiceManager sharedInstance] commonService] getPeacock:^(BOOL success, SKResponsePackage *response) {
        if (![response.data[@"peacock_pic"] isEqualToString:@""]&&response.data[@"peacock_pic"]!=nil) {
            [self loadAdvWithImage:response.data[@"peacock_pic"]];
            self.adLink = response.data[@"link"];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[TalkingData trackPageBegin:@"homepage"];
	[[UIApplication sharedApplication]
		setStatusBarHidden:NO
		     withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[TalkingData trackPageEnd:@"homepage"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] commonService] getPublicPage:^(BOOL success, SKIndexScanning *indexScanningInfo) {
        _scaningInfo = indexScanningInfo;   //1.扫一扫 2.时间段
        if ([indexScanningInfo.scanning_type integerValue] == 1) {
            
        } else if ([indexScanningInfo.scanning_type integerValue] == 2) {
            if (!indexScanningInfo.is_haved_reward) {
                [self loadZip];
            }
        }
        
        if (![indexScanningInfo.adv_pic isEqualToString:@""]&&indexScanningInfo.adv_pic!=nil) {
            //加载广告
            if ([self isNewDay] || ![self isSamePic]) {
                _activityNotificationView.hidden = NO;
                [_activityNotificationView show];
                [_activityNotificationView.contentImageView
                 sd_setImageWithURL:[NSURL URLWithString:self.scaningInfo.adv_pic]
                 completed:^(UIImage *image, NSError *error,
                             SDImageCacheType cacheType, NSURL *imageURL){
                 }];
            }
        }
    }];
}

- (BOOL)isNewDay {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    if (![locationString
          isEqualToString:
          [UD objectForKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION]]) {
        [UD setObject:locationString forKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION];
        return YES;
    } else {
        [UD setObject:locationString forKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION];
        return NO;
    }
}

- (BOOL)isSamePic {
    if ([self.scaningInfo.adv_pic
         isEqualToString:[UD stringForKey:ACTIVITY_NOTIFICATION_PIC_NAME]]) {
        return YES;
    } else {
        [UD setObject:self.scaningInfo.adv_pic forKey:ACTIVITY_NOTIFICATION_PIC_NAME];
        return NO;
    }
}

- (void)createUI {
	__weak __typeof(self) weakSelf = self;
	self.view.backgroundColor = COMMON_BG_COLOR;
    
    //切换城市按钮
    _changeCityButton = [UIButton new];
    [_changeCityButton setImage:[UIImage imageNamed:@"btn_local_beijing"] forState:UIControlStateNormal];
    [_changeCityButton addTarget:self action:@selector(didClickedChangeCityButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeCityButton];
    [_changeCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(82, 34));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@25);
    }];
    
    //任务按钮
    UIButton *taskButton = [UIButton new];
    [taskButton addTarget:self action:@selector(didClickTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [taskButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_taskbook"] forState:UIControlStateNormal];
    [taskButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_taskbook_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:taskButton];
    [taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(_changeCityButton);
        make.left.equalTo(@13.5);
    }];
    
    //扫一扫按钮
    UIButton *swipeButton = [UIButton new];
    [swipeButton addTarget:self action:@selector(didClickSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
    [swipeButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning"] forState:UIControlStateNormal];
    [self.view addSubview:swipeButton];
    [swipeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.bottom.equalTo(@(-68));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    [self.view layoutIfNeeded];
    
    NSArray *mascotName = @[@"零仔〇",@"懒惰", @"傲慢",@"暴怒",@"嫉妒",@"淫欲",@"饕餮"];
    float buttonWidth = (self.view.width-16*4)/3;
    for (int i=0; i<6; i++) {
        UIButton *mascotButton = [[UIButton alloc] initWithFrame:CGRectMake(16+(i%3)*(buttonWidth+16), 160+(i/3)*(buttonWidth+16), buttonWidth, buttonWidth)];
        [mascotButton addTarget:self action:@selector(didClickMascotButotn:) forControlEvents:UIControlEventTouchUpInside];
        [mascotButton setTitle:mascotName[i+1] forState:UIControlStateNormal];
        mascotButton.backgroundColor = COMMON_GREEN_COLOR;
        mascotButton.tag = 202+i;
        [self.view addSubview:mascotButton];
    }
    
    //活动通知
    _activityNotificationView = [[SKActivityNotificationView alloc]
                                 initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _activityNotificationView.hidden = YES;
    [self.view addSubview:_activityNotificationView];
}

- (void)loadZip {
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
    NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:_scaningInfo.pet_gif];
    NSString *unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [_scaningInfo.pet_gif stringByDeletingPathExtension]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
        [SSZipArchive unzipFileAtPath:zipFilePath
                        toDestination:unzipFilesPath
                            overwrite:YES
                             password:nil
                      progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                          
                      }
                    completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error){
                        
                    }];
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:_scaningInfo.pet_gif_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                         progress:nil
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                          NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
                                                                          NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:_scaningInfo.pet_gif];
                                                                          return [NSURL fileURLWithPath:zipFilePath];
                                                                      }
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                    if (filePath == nil)
                                                                        return;
                                                                    
                                                                    [SSZipArchive unzipFileAtPath:[filePath path]
                                                                                    toDestination:unzipFilesPath
                                                                                        overwrite:YES
                                                                                         password:nil
                                                                                  progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                                                                                      
                                                                                  }
                                                                                completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error){
                                                                                    
                                                                                }];
                                                                }];
        [downloadTask resume];
    }
}

- (void)loadAdvWithImage:(NSString*)imageUrl {
    NZAdView *adView = [[NZAdView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) image:[NSURL URLWithString:imageUrl]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAd)];
    tap.numberOfTapsRequired = 1;
    [adView addGestureRecognizer:tap];
    [KEY_WINDOW addSubview:adView];
}

#pragma mark - Actions

- (void)removeDimmingView {
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [_dimmingView removeFromSuperview];
    }];
}

- (void)didClickedChangeCityButton:(UIButton *)sender {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dimmingView.width, _dimmingView.height)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.8;
    [_dimmingView addSubview:alphaView];
    
    NSArray *cityNameArray = @[@"beijing", @"shanghai", @"guangzhou", @"chengdu", @"suzhou", @"hangzhou"];
    
    //Cities
    for (int i=0; i<6; i++) {
        UIButton *cityView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        [cityView addTarget:self action:@selector(didClickSelectedCityButton:) forControlEvents:UIControlEventTouchUpInside];
        cityView.tag = 100+i;
        [cityView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_local_%@", cityNameArray[i]]] forState:UIControlStateNormal];
        cityView.backgroundColor = COMMON_BG_COLOR;
        [_dimmingView addSubview:cityView];
        
        [UIView animateWithDuration:0.3 animations:^{
            cityView.top = 80+60*i;
        }];
    }
    
    _selectedButton = [self.view viewWithTag:100];
    [_selectedButton setBackgroundColor:COMMON_GREEN_COLOR];
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //TitleView
    UIView *changeCityTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    changeCityTitleView.backgroundColor = [UIColor blackColor];
    [_dimmingView addSubview:changeCityTitleView];
}

- (void)didClickSelectedCityButton:(UIButton *)sender {
    _selectedCityIndex = (long)sender.tag - 100;
    
    NSArray *cityNameArray = @[@"beijing", @"shanghai", @"guangzhou", @"chengdu", @"suzhou", @"hangzhou"];
    NSArray *cityCodeArray = @[@"010", @"021", @"020", @"028", @"0512", @"0571"];
    [_changeCityButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_local_%@", cityNameArray[_selectedCityIndex]]] forState:UIControlStateNormal];
    _selectedCityCode = cityCodeArray[_selectedCityIndex];
    [self removeDimmingView];
}

- (void)didClickTaskButton:(UIButton*)sender {
    NZTaskViewController *controller = [[NZTaskViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickSwipeButton:(UIButton *)sender {
    //判断相机是否开启
    AVAuthorizationStatus authStatus = [AVCaptureDevice
                                        authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        HTAlertView *alertView =
        [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
        [alertView show];
    } else {
        if ([_scaningInfo.scanning_type integerValue] == 1) {
            SKSwipeViewController *swipeViewController =
            [[SKSwipeViewController alloc] init];
            [self.navigationController pushViewController:swipeViewController animated:NO];
        } else if ([_scaningInfo.scanning_type integerValue] == 2) {
            HTARCaptureController *controller = [[HTARCaptureController alloc] init];
            controller.delegate = self;
            controller.pet_gif = _scaningInfo.pet_gif;
            controller.isHadReward = _scaningInfo.is_haved_reward;
            controller.rewardID = _scaningInfo.reward_id;
            [self presentViewController:controller animated:NO completion:nil];
        }
    }
}

- (void)didClickMascotButotn:(UIButton*)sender {
    NSInteger mid = sender.tag-200;
    NZTaskViewController *controller = [[NZTaskViewController alloc] initWithMascotID:mid];
    controller.cityCode = _selectedCityCode;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickAd {
    HTWebController *controller = [[HTWebController alloc] initWithURLString:self.adLink];
    controller.type = 1;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller reward:(SKReward *)reward {
    [controller dismissViewControllerAnimated:NO
                                   completion:^{
                                       [self removeDimmingView];
                                       [self showRewardViewWithReward:reward];
                                       [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
                                   }];
}

- (void)showRewardViewWithReward:(SKReward *)reward {
    NZQuestionFullScreenGiftView *rewardView = [[NZQuestionFullScreenGiftView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withReward:reward];
    [KEY_WINDOW addSubview:rewardView];
}

@end
