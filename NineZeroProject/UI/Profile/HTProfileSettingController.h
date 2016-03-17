//
//  HTProfileSettingController.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTUserInfo;
@interface HTProfileSettingController : UITableViewController
- (instancetype)initWithUserInfo:(HTUserInfo *)userInfo;
@end
