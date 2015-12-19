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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerJPushWithLaunchOptions:launchOptions];
    [self registerSMSService];
    [self registerQiniuService];
    
    [self createWindowAndVisible];
    
    CGSize imageSize = CGSizeMake(26, 32);
    UIImage *backImage = [self imageWithImage:[UIImage imageNamed:@"btn_navi_anchor_left"] scaledToSize:imageSize];
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
    UIBarButtonItem *backItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0) forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

#pragma mark - Test

- (void)test_cgi {
    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, id responseObject) {
        
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getQuestionDetailWithQuestionID:2015120821423814907 callback:^(BOOL success, HTQuestion *question) {
        DLog(@"%@", question);
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:1 count:10 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        
    }];
}

#pragma mark - Action

- (void)createWindowAndVisible {
//#ifdef DEBUG
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    HTPreviewQuestionController *rootController = [[HTPreviewQuestionController alloc] init];
//    self.window.rootViewController = rootController;
//    [self.window makeKeyAndVisible];
//#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HTLoginRootController *rootController = [[HTLoginRootController alloc] init];
    HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:rootController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
//#endif
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
}

@end
