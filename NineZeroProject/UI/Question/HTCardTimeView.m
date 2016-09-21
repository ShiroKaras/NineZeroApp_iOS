//
//  HTCardTimeView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/7.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTCardTimeView.h"
#import "HTUIHeader.h"
#import "SKHelperView.h"
#import "HTARCaptureController.h"

@interface HTCardTimeView ()
@property (weak, nonatomic) IBOutlet UILabel *mainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *decoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (nonatomic, strong) SKHelperGuideView *guideView;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, strong) HTQuestionInfo *questionInfo;
@property (nonatomic, strong) HTQuestion *question;
@end

@implementation HTCardTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[[UINib nibWithNibName:@"HTCardTimeView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.frame = self.bounds;
        [self addSubview:containerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setQuestion:(HTQuestion *)question andQuestionInfo:(HTQuestionInfo *)questionInfo{
    _questionInfo = questionInfo;
    _question = question;
    _endTime = (time_t)questionInfo.endTime;
    if (_question.questionID == _questionInfo.questionID) {
        if (question.isPassed == NO) {
            [self scheduleCountDownTimer];
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
            _decoImageView.hidden = YES;
            _mainTimeLabel.hidden = YES;
            _detailTimeLabel.hidden = YES;
            _resultImageView.hidden = NO;
            _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
            if (question.isPassed) {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_sucess"]];
            } else {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_gameover"]];
            }
        }
    } else {
        _decoImageView.hidden = YES;
        _mainTimeLabel.hidden = YES;
        _detailTimeLabel.hidden = YES;
        _resultImageView.hidden = NO;
        if (question.isPassed) {
            [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_sucess"]];
        } else {
            if (question.type == 0) {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_AR"]];
            } else {
                _resultImageView.hidden = YES;
            }
        }
    }
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    _decoImageView.hidden = NO;
    _mainTimeLabel.hidden = NO;
    _detailTimeLabel.hidden = YES;
    _resultImageView.hidden = YES;
    
    //TODO: 更改TimeView
    if (delta > 0) {
        if (delta < oneHour * 36 && FIRST_TYPE_2) {
            [self showGuideviewWithType:SKHelperGuideViewType2];
            [UD setBool:YES forKey:@"firstLaunchType2"];
        }
        // 小于1小时
        _mainTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
        _mainTimeLabel.textColor = COMMON_PINK_COLOR;
        _decoImageView.hidden = YES;
        _detailTimeLabel.hidden = NO;
        _detailTimeLabel.text = [NSString stringWithFormat:@"%02ld", second];
        _detailTimeLabel.textColor = COMMON_PINK_COLOR;
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

- (void)showGuideviewWithType:(SKHelperGuideViewType)type {
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [UIColor blackColor];
    
    _guideView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:type];
    [_guideView.button3 addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _guideView.alpha = 0;
    
    [KEY_WINDOW addSubview:blackView];
    [KEY_WINDOW bringSubviewToFront:blackView];
    [KEY_WINDOW addSubview:_guideView];
    [KEY_WINDOW bringSubviewToFront:_guideView];
    
    [UIView animateWithDuration:1.2 animations:^{
        blackView.alpha = 0;
        _guideView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)completeButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _guideView.alpha = 0;
    } completion:^(BOOL finished) {
        [_guideView removeFromSuperview];
        [self showAlert];
    }];
}

- (void)showAlert {
    //通知Alert
    if (![UD boolForKey:@"hasShowPushAlert"]&&![self isAllowedNotification]) {
        if (!FIRST_LAUNCH){
            //未显示过
            HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypePush];
            [alertView show];
            [UD setBool:YES forKey:@"hasShowPushAlert"];
        }
    }
    
    //地理位置Alert
    //判断GPS是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DLog(@"authorizationStatus -> %d", [CLLocationManager authorizationStatus]);
        }else {
            HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
            [alertView show];
        }
    }else {
        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeLocation];
        [alertView show];
    }
}

- (BOOL)isAllowedNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {// system is iOS8 +
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    else {// iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

@end

@interface HTRecordView ()

@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HTRecordView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[[UINib nibWithNibName:@"HTRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.frame = self.bounds;
        [self addSubview:containerView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setQuestion:(HTQuestion *)question {
    self.coinLabel.text = [NSString stringWithFormat:@"%ld", question.gold];
    time_t oneHour = 3600;
    time_t hour = question.use_time / oneHour;
    time_t minute = (question.use_time % oneHour) / 60;
    time_t second = question.use_time - hour * oneHour - minute * 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
}

@end
