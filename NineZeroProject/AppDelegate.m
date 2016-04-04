//
//  AppDelegate.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "HTLoginRootController.h"
#import "HTServiceManager.h"
#import "HTNavigationController.h"
#import "HTPreviewQuestionController.h"
#import <Qiniu/QiniuSDK.h>
#import "HTLogicHeader.h"
#import "HTUIHeader.h"
#import "INTULocationManager.h"
#import "HTMainViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerJPushWithLaunchOptions:launchOptions];
    [self registerQiniuService];
    
    [self createWindowAndVisible];
    
    // 光标颜色
    [[UITextField appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
    [[UITextView appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
            backgroundTask = UIBackgroundTaskInvalid;
        });
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken : %@", deviceToken);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification : %@", userInfo);
    [APService handleRemoteNotification:userInfo];
}

// 1. 问题提示
// 2. 系统通知
// 3. 零仔文章
// 4. 休息日文章
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    NSString *method = userInfo[@"method"];
//    NSDictionary *dataDict = userInfo[@"data"];
    
    NSLog(@"didReceiveRemoteNotification, completionHandler: %@", userInfo);
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - Action

- (void)createWindowAndVisible {
    if ([[[HTServiceManager sharedInstance] loginService] loginUser] != nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _mainController = [[HTMainViewController alloc] init];
//        HTPreviewQuestionController *rootController = [[HTPreviewQuestionController alloc] init];
        self.window.rootViewController = _mainController;
        [self.window makeKeyAndVisible];
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark - Location

- (void)registerLocation {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
        } else if (status == INTULocationStatusTimedOut) {
        } else {
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
    if ([[HTStorageManager sharedInstance] getUserID]) {
        [APService setTags:[NSSet setWithObject:@"iOS"] alias:[[HTStorageManager sharedInstance] getUserID] callbackSelector:nil target:nil];
    }
}

@end
