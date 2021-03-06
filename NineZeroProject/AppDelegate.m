//
//  AppDelegate.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/2.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "AppDelegate.h"
#import "HTLogicHeader.h"
#import "HTNavigationController.h"
#import "HTUIHeader.h"
#import "JPUSHService.h"
#import "SKLaunchAnimationViewController.h"
#import "SKLoginRootViewController.h"
#import "NZTabbarViewController.h"
#import <Qiniu/QiniuSDK.h>

#import "UMMobClick/MobClick.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "TalkingData.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "ClientConfiguration.h"

@interface AppDelegate ()

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) SKLaunchAnimationViewController *launchViewController;
@property (nonatomic, strong) NSString *trackViewURL;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	_cityCode = @"010";
	_active = true;

	[self registerJPushWithLaunchOptions:launchOptions];
	[self registerAMap];
	[self registerLocation];
	[self registerQiniuService];
	[self registerShareSDK];
	[self registerUmeng];
	[self registerUserAgent];
	[self registerTalkingData];

	[NSThread sleepForTimeInterval:2];
	[self createWindowAndVisibleWithOptions:launchOptions];

	// 光标颜色
	[[UITextField appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
	[[UITextView appearance] setTintColor:[UIColor colorWithHex:0xed203b]];

	[[AFNetworkReachabilityManager sharedManager] startMonitoring];

	return YES;
}

#if DEBUG
- (NSArray *)keyCommands {
	UIKeyCommand *debugHotKey =
		[UIKeyCommand keyCommandWithInput:@"D"
				    modifierFlags:UIKeyModifierCommand | UIKeyModifierShift
					   action:@selector(debugHotKey:)];
	return @[debugHotKey];
}

- (void)debugHotKey:(UIKeyCommand *)keyCommand {
	//如果出现Bug跳转View
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
	(void)application;
	_active = false;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	__block UIBackgroundTaskIdentifier backgroundTask =
		[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120.0 * NSEC_PER_SEC)),
				   dispatch_get_main_queue(), ^{
				       [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
				       backgroundTask = UIBackgroundTaskInvalid;
				   });
		}];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	DLog(@"applicationWillEnterForeground");
	[[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	DLog(@"applicationDidBecomeActive");
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	_active = true;
	[JPUSHService resetBadge];
}

- (void)application:(UIApplication *)application
	didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	DLog(@"didRegisterForRemoteNotificationsWithDeviceToken : %@", deviceToken);
	[JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
	didReceiveRemoteNotification:(NSDictionary *)userInfo {
	DLog(@"didReceiveRemoteNotification : %@", userInfo);
	[JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application
	didReceiveRemoteNotification:(NSDictionary *)userInfo
	      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	DLog(@"didReceiveRemoteNotification, completionHandler: %@ "
	     @"\nApplicationState,%ld",
	     userInfo, (long)[UIApplication sharedApplication].applicationState);
	if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
		[self handleAPNsDict:userInfo];
	}
	[JPUSHService handleRemoteNotification:userInfo];
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillTerminate:(UIApplication *)application {
	_active = false;
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//
//}

#pragma mark - Action

// 1. 问题提示
// 2. 系统通知
// 3. 零仔文章
// 4. 休息日文章
- (void)handleAPNsDict:(NSDictionary *)dict {
	//    NSString *method = dict[@"method"];
	//    NSDictionary *dataDict = dict[@"data"];
}

- (void)createWindowAndVisibleWithOptions:(NSDictionary *)launchOptions {
	NSString *userID = [[SKStorageManager sharedInstance] getUserID];
	if (userID != nil) {
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_mainController = [[NZTabbarViewController alloc] init];
		HTNavigationController *navController =
			[[HTNavigationController alloc] initWithRootViewController:_mainController];
		self.window.rootViewController = navController;
		[self.window makeKeyAndVisible];
		//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
		// 用户通过点击图标启动程序 还是  点击通知启动程序
		// 获取启动时收到的APN
		NSDictionary *remoteNotification =
			[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (remoteNotification) {
			[self handleAPNsDict:remoteNotification];
		}
	} else {
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		SKLoginRootViewController *rootController = [[SKLoginRootViewController alloc] init];
		HTNavigationController *navController =
			[[HTNavigationController alloc] initWithRootViewController:rootController];
		self.window.rootViewController = navController;
		[self.window makeKeyAndVisible];

//		if (![UD boolForKey:@"everLaunch"]) {
//			self.launchViewController = [[SKLaunchAnimationViewController alloc] init];
//			[self.window addSubview:self.launchViewController.view];
//			__weak AppDelegate *weakSelf = self;
//			self.launchViewController.didSelectedEnter = ^() {
//			    [UIView animateWithDuration:0.3
//				    animations:^{
//					weakSelf.launchViewController.view.alpha = 0;
//				    }
//				    completion:^(BOOL finished) {
//					weakSelf.launchViewController = nil;
//					//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//				    }];
//			};
//		} else {
//			//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//		}

		[[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];

		// 用户通过点击图标启动程序 还是  点击通知启动程序
		// 获取启动时收到的APN
		NSDictionary *remoteNotification =
			[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (remoteNotification) {
			[self handleAPNsDict:remoteNotification];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		UIApplication *application = [UIApplication sharedApplication];
		[application openURL:[NSURL URLWithString:_trackViewURL]];
	}
}

- (void)registerUserAgent {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
	NSString *secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];

	NSString *newUagent = [NSString stringWithFormat:@"%@ 90app529D", secretAgent];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newUagent forKey:@"UserAgent"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)registerTalkingData {
	// App ID: 在 App Analytics
	// 创建应用后，进入数据报表页中，在“系统设置”-“编辑应用”页面里查看App ID。
	// 渠道 ID: 是渠道标识符，可通过不同渠道单独追踪数据。
	[TalkingData sessionStarted:[[ClientConfiguration sharedInstance] TalkingDataSession] withChannelId:@"iOS"];
	[TalkingData setVersionWithCode:[[[NSBundle mainBundle] infoDictionary]
						objectForKey:@"CFBundleShortVersionString"]
				   name:[[[NSBundle mainBundle] infoDictionary]
						objectForKey:@"CFBundleDisplayName"]];
}

#pragma mark - Location

- (void)registerAMap {
	[AMapServices sharedServices].apiKey = [[ClientConfiguration sharedInstance] AMapServicesAPIKey];
}

- (void)registerLocation {
	self.locationManager = [[AMapLocationManager alloc] init];
	// 带逆地理信息的一次定位（返回坐标和地址信息）
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	//   定位超时时间，可修改，最小2s
	self.locationManager.locationTimeout = 2;
	//   逆地理请求超时时间，可修改，最小2s
	self.locationManager.reGeocodeTimeout = 2;

	// 带逆地理（返回坐标和地址信息）
	[self.locationManager
		requestLocationWithReGeocode:YES
			     completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode,
					       NSError *error) {
				 if (error) {
					 DLog(@"locError:{%ld - %@};", (long)error.code,
					      error.localizedDescription);
					 //            _cityCode = @"010";
				 }
				 DLog(@"location:%@", location);
				 if (regeocode) {
					 DLog(@"citycode:%@", regeocode.citycode);
					 //            _cityCode = @"010";
				 }
			     }];
}

#pragma mark - QiNiu

- (void)registerQiniuService {
	[[[SKServiceManager sharedInstance] commonService]
		getQiniuPublicTokenWithCompletion:^(BOOL success, NSString *token){
		}];
}

#pragma mark - Umeng

- (void)registerUmeng {
	//    [MobClick startWithAppkey:@"574011a6e0f55acb3200270a" reportPolicy:BATCH
	//    channelId:@""];
	NSString *version =
		[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	[MobClick setAppVersion:version];
	UMConfigInstance.appKey = [[ClientConfiguration sharedInstance] UMAnalyticsConfigAppKey];
	UMConfigInstance.channelId = @"";
	UMConfigInstance.ePolicy = BATCH;
	[MobClick startWithConfigure:UMConfigInstance];
	[MobClick setLogEnabled:YES];
}

#pragma mark - ShareSDK

- (void)registerShareSDK {
	/**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login
         * 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */

	// 117f8a0b99f70
	[ShareSDK registerApp:[[ClientConfiguration sharedInstance] ShareSDKAppKey]

		activePlatforms:@[
			@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeWechat), @(SSDKPlatformTypeQQ)
		]
		onImport:^(SSDKPlatformType platformType) {
		    switch (platformType) {
			    case SSDKPlatformTypeWechat:
				    [ShareSDKConnector connectWeChat:[WXApi class]];
				    break;
			    case SSDKPlatformTypeQQ:
				    [ShareSDKConnector connectQQ:[QQApiInterface class]
					       tencentOAuthClass:[TencentOAuth class]];
				    break;
			    case SSDKPlatformTypeSinaWeibo:
				    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
				    break;
			    default:
				    break;
		    }
		}
		onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {

		    switch (platformType) {
			    case SSDKPlatformTypeSinaWeibo:
				    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
				    [appInfo SSDKSetupSinaWeiboByAppKey:[[ClientConfiguration sharedInstance] SSDKPlatformTypeSinaWeiboAppKey]
							      appSecret:[[ClientConfiguration sharedInstance] SSDKPlatformTypeSinaWeiboAppSecret]
							    redirectUri:[[ClientConfiguration sharedInstance] SSDKPlatformTypeSinaWeiboRedirectUri]
							       authType:SSDKAuthTypeBoth];
				    break;
			    case SSDKPlatformTypeWechat:
				    [appInfo SSDKSetupWeChatByAppId:[[ClientConfiguration sharedInstance] SSDKPlatformTypeWechatAppId]
							  appSecret:[[ClientConfiguration sharedInstance] SSDKPlatformTypeWechatAppSecret]];
				    break;
			    case SSDKPlatformTypeQQ:
				    [appInfo SSDKSetupQQByAppId:[[ClientConfiguration sharedInstance] SSDKPlatformTypeQQAppId]
							 appKey:[[ClientConfiguration sharedInstance] SSDKPlatformTypeQQAppKey]
						       authType:SSDKAuthTypeBoth];
				    break;
			    default:
				    break;
		    }
		}];
}

#pragma mark - JPush

- (void)registerJPushWithLaunchOptions:(NSDictionary *)launchOptions {
	// JPush
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		[JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
								  UIUserNotificationTypeSound |
								  UIUserNotificationTypeAlert)
						      categories:nil];
	}

	//    [JPUSHService setupWithOption:launchOptions];
	[JPUSHService setupWithOption:launchOptions
			       appKey:[[ClientConfiguration sharedInstance] JPUSHServiceAppKey]
			      channel:[[ClientConfiguration sharedInstance] JPUSHServiceChannel]
		     apsForProduction:true];
	[JPUSHService resetBadge];
	if ([[SKStorageManager sharedInstance] getUserID]) {
		[JPUSHService setTags:[NSSet setWithObject:@"iOS"]
				   alias:[[SKStorageManager sharedInstance] getUserID]
			callbackSelector:nil
				  object:nil];
	}
}

@end
