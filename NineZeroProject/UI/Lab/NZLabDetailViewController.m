//
//  NZLabDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabDetailViewController.h"

@interface NZLabDetailViewController ()
@property (nonatomic, strong) NSString *topicID;
@end

@implementation NZLabDetailViewController

- (instancetype)initWithTopicID:(NSString *)topicID {
    self = [super init];
    if (self) {
        _topicID = topicID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
