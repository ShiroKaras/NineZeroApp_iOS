//
//  HTRelaxController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTRelaxController.h"
#import "HTUIHeader.h"

@interface HTRelaxController () {
    UIVisualEffectView *_visualEfView;
    UIImageView *_backgroundImageView;
}
@property (weak, nonatomic) IBOutlet UIImageView *nextCard;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UIImageView *relaxLogo;
@property (weak, nonatomic) IBOutlet UIImageView *deco1;
@end

@implementation HTRelaxController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"bg_article"];
    [self.view addSubview:_backgroundImageView];
    
    if (IOS_VERSION >= 8.0) {
        _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _visualEfView.alpha = 1.0;
        _visualEfView.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_backgroundImageView addSubview:_visualEfView];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _visualEfView.frame = self.view.bounds;
    _backgroundImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:_backgroundImageView];
}

- (IBAction)didClickMoreButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
