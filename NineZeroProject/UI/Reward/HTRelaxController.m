//
//  HTRelaxController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTRelaxController.h"
#import "HTUIHeader.h"
#import <UIImage+animatedGIF.h>

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

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;


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

    [self hideTextTips];
    
    [[[HTServiceManager sharedInstance] questionService] getRelaxDayInfo:^(BOOL success, HTResponsePackage *response) {
//        _endTime = 1460908800 + 3600*24*2;
//        [self scheduleCountDownTimer];
        if (success && response.resultCode == 0) {
            NSDictionary *dataDict = response.data;
            NSInteger contentType = [dataDict[@"content_type"] integerValue];
            time_t date = [dataDict[@"date"] integerValue];
            contentType = MIN(0, MAX(2, contentType));
            NSString *jsonString = [NSString stringWithFormat:@"%@", dataDict[@"content_data"]];
            NSError *jsonError;
            NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
            _endTime = date + 3600*24;
            [self scheduleCountDownTimer];
            if (contentType == 0) {
                // 文章
                [self hideGIFTips];
                [self hideMovieTips];
            } else if (contentType == 1) {
                // 零仔gif链接
                [self hideMovieTips];
                [self hideTextTips];
                UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:jsonDict[@"pic_url"]]];
                _gifImageView.image = gifImage;
                [_gifImageView startAnimating];
            } else if (contentType == 2) {
                // 视频url链接和食品标题
                [self hideGIFTips];
                [self hideTextTips];
                self.movieTitle.text = [NSString stringWithFormat:@"%@", jsonDict[@"title"]];
            }
        }
    }];
    
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

- (void)hideMovieTips {
    self.movieCover.hidden = YES;
    self.moviePlay.hidden = YES;
    self.moreButton.height = YES;
    self.movieTitle.hidden = YES;
}

- (void)hideGIFTips {
    self.gifImageView.hidden = YES;
}

#pragma mark - Action

- (void)didClickBackView {
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickPlayButton:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickMoreButton:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
