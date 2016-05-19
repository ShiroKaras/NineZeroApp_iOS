//
//  AppDelegate.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/2.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "HTLoginRootController.h"
#import "HTServiceManager.h"
#import "HTNavigationController.h"
#import <Qiniu/QiniuSDK.h>
#import "HTLogicHeader.h"
#import "HTUIHeader.h"
#import "HTRelaxController.h"
#import "INTULocationManager.h"
#import "HTMainViewController.h"
#import "HTArticleController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface AppDelegate ()

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _cityCode = @"010";
    [self registerJPushWithLaunchOptions:launchOptions];
    [self registerQiniuService];
    [self registerShareSDK];
    [self registerAMap];
    [self registerLocation];
    
    [self createWindowAndVisibleWithOptions:launchOptions];
    
    // 光标颜色
    [[UITextField appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
    [[UITextView appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    return YES;
}

#if DEBUG
- (NSArray *)keyCommands {
    UIKeyCommand *debugHotKey = [UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierCommand | UIKeyModifierShift action:@selector(debugHotKey:)];
    return @[debugHotKey];
}

- (void)debugHotKey:(UIKeyCommand *)keyCommand {
    HTRelaxController *relaxController = [[HTRelaxController alloc] init];
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while (vc.presentedViewController) vc = vc.presentedViewController;
    [vc presentViewController:relaxController animated:YES completion:nil];
}
#endif

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
            backgroundTask = UIBackgroundTaskInvalid;
        });
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DLog(@"applicationDidBecomeActive");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService resetBadge];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DLog(@"didRegisterForRemoteNotificationsWithDeviceToken : %@", deviceToken);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DLog(@"didReceiveRemoteNotification : %@", userInfo);
    [APService handleRemoteNotification:userInfo];
}

// 1. 问题提示
// 2. 系统通知
// 3. 零仔文章
// 4. 休息日文章
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *method = userInfo[@"method"];
    NSDictionary *dataDict = userInfo[@"data"];
    // TODO: 通过type去拉不同的数据
    DLog(@"didReceiveRemoteNotification, completionHandler: %@ \nApplicationState,%ld", userInfo, [UIApplication sharedApplication].applicationState);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        if ([method isEqual:@1]) {
            [[[HTServiceManager sharedInstance] profileService] getArticle:[dataDict[@"article_id"] integerValue] completion:^(BOOL success, HTArticle *articles) {
                HTArticleController *articleViewController = [[HTArticleController alloc] initWithArticle:articles];
                [self.mainController presentViewController:articleViewController animated:YES completion:nil];
            }];
        }
    }
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//
//}

#pragma mark - Action

- (void)createWindowAndVisibleWithOptions:(NSDictionary*)launchOptions {
    if ([[[HTServiceManager sharedInstance] loginService] loginUser] != nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _mainController = [[HTMainViewController alloc] init];
        self.window.rootViewController = _mainController;
        [self.window makeKeyAndVisible];
        
        // 用户通过点击图标启动程序 还是  点击通知启动程序
        // 获取启动时收到的APN
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            NSString *method = remoteNotification[@"method"];
            NSDictionary *dataDict = remoteNotification[@"data"];
            if ([method isEqual:@1]) {
                [[[HTServiceManager sharedInstance] profileService] getArticle:[dataDict[@"article_id"] integerValue] completion:^(BOOL success, HTArticle *articles) {
                    HTArticleController *articleViewController = [[HTArticleController alloc] initWithArticle:articles];
                    [self.mainController presentViewController:articleViewController animated:YES completion:nil];
                }];
            }
        }
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
        [[[HTServiceManager sharedInstance] profileService] updateUserInfoFromSvr];
        
        // 用户通过点击图标启动程序 还是  点击通知启动程序
        // 获取启动时收到的APN
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            NSString *method = remoteNotification[@"method"];
            NSDictionary *dataDict = remoteNotification[@"data"];
            if ([method isEqual:@1]) {
                [[[HTServiceManager sharedInstance] profileService] getArticle:[dataDict[@"article_id"] integerValue] completion:^(BOOL success, HTArticle *articles) {
                    HTArticleController *articleViewController = [[HTArticleController alloc] initWithArticle:articles];
                    [self.mainController presentViewController:articleViewController animated:YES completion:nil];
                }];
            }
        }
    }
}

#pragma mark - Location

- (void)registerAMap{
    [AMapLocationServices sharedServices].apiKey = @"2cb1a94b85ace5b91f5f00b37c0422e9";
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
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            _cityCode = @"010";
        }
        DLog(@"location:%@", location);
        if (regeocode){
            DLog(@"citycode:%@", regeocode.citycode);
//            _cityCode = @"010";
        }
    }];
}

#pragma mark - QiNiu

- (void)registerQiniuService {
    [[[HTServiceManager sharedInstance] loginService] getQiniuPrivateTokenWithCompletion:^(NSString *token) {
    }];
    [[[HTServiceManager sharedInstance] loginService] getQiniuPublicTokenWithCompletion:^(NSString *token) {
    }];
}

#pragma mark - ShareSDK

-(void)registerShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    //117f8a0b99f70
    [ShareSDK registerApp:@"117f8a0b99f70"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1266848941"
                                           appSecret:@"af1a2b939f9d65313ae08ce40e4428b5"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxfb8f0b079901a486"
                                       appSecret:@"9b878253531427e0216f4c456a6216bc"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105336032"
                                      appKey:@"JBvAhpWdPjMxhGJt"
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
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [APService setupWithOption:launchOptions];
    [APService resetBadge];
    if ([[HTStorageManager sharedInstance] getUserID]) {
        [APService setTags:[NSSet setWithObject:@"iOS"] alias:[[HTStorageManager sharedInstance] getUserID] callbackSelector:nil target:nil];
    }
}

@end
