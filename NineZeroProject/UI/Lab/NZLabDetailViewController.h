//
//  NZLabDetailViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZLabDetailViewController : UIViewController
@property (nonatomic, strong) NSString *TopicThumbnailUrl;

- (instancetype)initWithTopicID:(NSString *)topicID title:(NSString *)title;

@end
