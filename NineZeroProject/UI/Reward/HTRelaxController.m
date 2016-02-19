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
@property (weak, nonatomic) IBOutlet UIImageView *movieCover;
@property (weak, nonatomic) IBOutlet UIButton *moviePlay;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@property (weak, nonatomic) IBOutlet UILabel *textTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *textBottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation HTRelaxController {
    time_t _endTime;
}

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
    
    _endTime = time(NULL) + 40000;
    [self scheduleCountDownTimer];

    [self  hideTextTips];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBackView)];
    [self.view addGestureRecognizer:tap];
}

- (void)scheduleCountDownTimer {
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    if (delta < 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
        return;
    }
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    self.secondsLabel.text = [NSString stringWithFormat:@"%02ld", second];
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _visualEfView.frame = self.view.bounds;
    _backgroundImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:_backgroundImageView];
}

#pragma mark - Tool Method

- (void)hideTextTips {
    self.textTopLabel.hidden = YES;
    self.textBottomLabel.hidden = YES;
    self.moreButton.hidden = YES;    
}

#pragma mark - Action

- (void)didClickBackView {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickPlayButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickMoreButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
