//
//  AppDelegate.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import <SMS_SDK/SMS_SDK.h>
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
    [self registerSMSService];
    [self registerQiniuService];
    
    [[[HTServiceManager sharedInstance] mascotService] getUserProps:^(BOOL success, NSArray<HTMascotProp *> *props) {
        
    }];
    
    [[[HTServiceManager sharedInstance] mascotService] getUserMascots:^(BOOL success, NSArray<HTMascot *> *mascots) {
        
    }];
    
    [self createWindowAndVisible];
    
    // 光标颜色
    [[UITextField appearance] setTintColor:[UIColor colorWithHex:0xed203b]];
    [[UITextView appearance] setTintColor:[UIColor colorWithHex:0xed203b]];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
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
    [[[HTServiceManager sharedInstance] loginService] getQiniuTokenWithCompletion:^(NSString *token) {
        if (token.length != 0 ) {
            
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
}

#pragma mark - SMS

- (void)registerSMSService {
    // SMS
    [SMS_SDK registerApp:@"b805a16e1149" withSecret:@"054f27dedc33c58a97afb1781406678b"];
    [SMS_SDK enableAppContactFriends:NO];
}

@end
