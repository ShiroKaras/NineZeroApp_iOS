//
//  HTRelaxController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTRelaxController.h"
#import "HTRelaxCoverController.h"
#import "HTUIHeader.h"
#import <UIImage+animatedGIF.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HTArticleController.h"

typedef enum : NSUInteger {
    HTRelaxTypeArticle,
    HTRelaxTypeGif,
    HTRelaxTypeVedio,
    HTRelaxTypeUnknown,
} HTRelaxType;

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

@property (nonatomic, assign) HTRelaxType relaxType;

@property (nonatomic, strong) HTRelaxCoverController *coverController;
@property (nonatomic, strong) HTArticle *currentArticle;
@property (nonatomic, strong) NSString *vedioUrlString;
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayer;
@end

@implementation HTRelaxController {
    time_t _endTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_backgroundImageView];
    
    [[[HTServiceManager sharedInstance] questionService] getCoverPicture:^(BOOL success, HTResponsePackage *response) {
        if (success && response.resultCode == 0) {
            NSDictionary *dataDict = response.data;
            
            [_backgroundImageView sd_setImageWithURL:dataDict[@"rest_cover"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
    }];
    
    
    if (IOS_VERSION >= 8.0) {
        _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _visualEfView.alpha = 1.0;
        _visualEfView.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_backgroundImageView addSubview:_visualEfView];
    }
    
    [self showViewWithRelaxType:HTRelaxTypeUnknown];
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
            _relaxType = contentType;
            if (contentType == 0) {
                // 文章
                [self showViewWithRelaxType:HTRelaxTypeArticle];
                if (jsonDict[@"article_id"]) {
                    NSString *articleID = [NSString stringWithFormat:@"%@", jsonDict[@"article_id"]];
                    [[[HTServiceManager sharedInstance] profileService] getArticle:[articleID integerValue] completion:^(BOOL success, HTArticle *article) {
                        if (success) {
                            _currentArticle = article;
                            self.textTopLabel.text = article.articleTitle;
                            self.textBottomLabel.text = article.article_subtitle;
                        }
                    }];
                }
            } else if (contentType == 1) {
                // 零仔gif链接
                [self showViewWithRelaxType:HTRelaxTypeGif];
                UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", jsonDict[@"pic_url"]]]];
                _gifImageView.image = gifImage;
                [_gifImageView startAnimating];
            } else if (contentType == 2) {
                [self showViewWithRelaxType:HTRelaxTypeVedio];
                self.movieTitle.text = [NSString stringWithFormat:@"%@", jsonDict[@"title"]];
                self.vedioUrlString = [NSString stringWithFormat:@"%@", jsonDict[@"url"]];
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

- (void)hideTextTips:(BOOL)hide {
    self.textTopLabel.hidden = hide;
    self.textBottomLabel.hidden = hide;
    self.moreButton.hidden = hide;
}

- (void)hideMovieTips:(BOOL)hide {
    self.movieCover.hidden = hide;
    self.moviePlay.hidden = hide;
    self.movieTitle.hidden = hide;
}

- (void)hideGIFTips:(BOOL)hide {
    self.gifImageView.hidden = hide;
}

- (void)showCoverPicture {
    [UIView animateWithDuration:0.3 animations:^{
        _coverController.view.alpha = 1;
    }];
}

#pragma mark - Action

- (void)didClickBackView {
    _coverController = [[HTRelaxCoverController alloc] init];
    _coverController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _coverController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _coverController.bgImageView.image = _backgroundImageView.image;
    [self presentViewController:_coverController animated:YES completion:nil];
}

- (IBAction)didClickPlayButton:(UIButton *)sender {
    _moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:_vedioUrlString];
    _moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_moviePlayer animated:YES completion:nil];
    [_moviePlayer.moviePlayer play];
}

- (IBAction)didClickMoreButton:(UIButton *)sender {
    HTArticleController *articleController = [[HTArticleController alloc] initWithArticle:_currentArticle];
    [self presentViewController:articleController animated:YES completion:nil];
}

#pragma mark - Tool Method

- (void)showViewWithRelaxType:(HTRelaxType)type {
    switch (type) {
        case HTRelaxTypeArticle: {
            [self hideTextTips:NO];
            [self hideGIFTips:YES];
            [self hideMovieTips:YES];
            break;
        }
        case HTRelaxTypeVedio: {
            [self hideTextTips:YES];
            [self hideGIFTips:YES];
            [self hideMovieTips:NO];
            break;
        }
        case HTRelaxTypeGif: {
            [self hideTextTips:YES];
            [self hideMovieTips:YES];
            [self hideGIFTips:NO];
            break;
        }
        default:
            [self hideGIFTips:YES];
            [self hideMovieTips:YES];
            [self hideTextTips:YES];
            break;
    }
}

@end
