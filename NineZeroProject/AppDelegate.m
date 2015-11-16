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
#import "HTCGIManager.h"
#import "HTServiceManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[HTServiceManager sharedInstance] createStorageServiceIfNeed];
    
    [self registerJPushWithLaunchOptions:launchOptions];
    [self registerSMSService];
    
    [self createWindowAndVisible];
    
    HTLoginUser *user = [[HTLoginUser alloc] init];
    user.user_name = @"123";
    user.user_password = @"3212222222";
    user.user_email = @"40988812@qq.com";
    user.user_mobile = @"111111111111";
    user.code = @"1234";
    user.user_area_id = @"1";
	user.user_avatar = @"http://www.baidu.com/";
	
    // test code
    [[[HTServiceManager sharedInstance] loginService] registerWithUser:user];
	[[[HTServiceManager sharedInstance] loginService] loginWithUser:user];
	
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
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
    //    [SMSSDK registerApp:appKey withSecret:appSecret];
    [SMS_SDK registerApp:@"com.test" withSecret:@"testSecret"];
}

@end
