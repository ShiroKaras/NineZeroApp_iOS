//
//  NZTaskDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskDetailViewController.h"
#import "HTUIHeader.h"
#import "NZTaskDetailView.h"
#import "HTARCaptureController.h"
#import "NZQuestionGiftView.h"
#import "SSZipArchive.h"
#import "SKHelperView.h"

@interface NZTaskDetailViewController () <UIScrollViewDelegate, HTARCaptureControllerDelegate>
@property (nonatomic, strong) SKStrongholdItem *detail;
@property (nonatomic, strong) UIView        *dimmingView;
@property (nonatomic, strong) UIImageView   *titleImageView;
@property (nonatomic, strong) UIView        *tabBackView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *indicatorLine;
@property (nonatomic, strong) UIButton      *button1;
@property (nonatomic, strong) UIButton      *button2;
@property (nonatomic, strong) UIButton      *addTaskButton;
//@property (nonatomic, strong) UIView        *tipsBackView;
@property (nonatomic, assign) BOOL          isAddTaskList;
@end

@implementation NZTaskDetailViewController

- (instancetype)initWithID:(NSString*)sid {
    self = [super init];
    if (self) {
        _detail = [SKStrongholdItem new];
        _detail.id = sid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"isAddTaskList" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self createUI];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isAddTaskList"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] strongholdService] getStrongholdInfoWithID:_detail.id callback:^(BOOL success, SKStrongholdItem *strongholdItem) {
        _detail = strongholdItem;
        self.isAddTaskList = strongholdItem.task_status;
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:strongholdItem.bigpic] placeholderImage:[UIImage imageNamed:@"img_labdetail_loading"]];
        
        NZTaskDetailView *detailView = [[NZTaskDetailView alloc] initWithFrame:CGRectMake(0, _titleImageView.bottom, self.view.width, 1000) withModel:strongholdItem];
        [_scrollView addSubview:detailView];
        
        _scrollView.contentSize = CGSizeMake(self.view.width, detailView.viewHeight+16+_titleImageView.height);
        
        //加载零仔动图压缩包
        NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
        NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:strongholdItem.pet_gif];
        NSString *unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [strongholdItem.pet_gif stringByDeletingPathExtension]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
            [SSZipArchive unzipFileAtPath:zipFilePath
                            toDestination:unzipFilesPath
                                overwrite:YES
                                 password:nil
                          progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                              
                          }
                        completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error){
                            
                        }];
        } else {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSURL *URL = [NSURL URLWithString:strongholdItem.pet_gif_url];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                             progress:nil
                                                                          destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                              NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
                                                                              NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:strongholdItem.pet_gif];
                                                                              return [NSURL fileURLWithPath:zipFilePath];
                                                                          }
                                                                    completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                        if (filePath == nil)
                                                                            return;
                                                                        
                                                                        [SSZipArchive unzipFileAtPath:[filePath path]
                                                                                        toDestination:unzipFilesPath
                                                                                            overwrite:YES
                                                                                             password:nil
                                                                                      progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                                                                                          
                                                                                      }
                                                                                    completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error){
                                                                                        
                                                                                    }];
                                                                    }];
            [downloadTask resume];
        }
    }];
}

- (void)createUI {
    WS(weakSelf);
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //MainView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    _titleImageView.image = [UIImage imageNamed:@"img_labdetail_loading"];
    _titleImageView.layer.masksToBounds = YES;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_titleImageView];
    
    UIButton *scanningButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.right-16-ROUND_WIDTH_FLOAT(40), _titleImageView.bottom-16-ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40), ROUND_WIDTH_FLOAT(40))];
    [scanningButton addTarget:self action:@selector(didClickScanningButton:) forControlEvents:UIControlEventTouchUpInside];
    [scanningButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning"] forState:UIControlStateNormal];
    [scanningButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning_highlight"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:scanningButton];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = COMMON_TITLE_BG_COLOR;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(@49);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];

    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13.5);
        make.centerY.equalTo(bottomView);
    }];
    
    _addTaskButton = [UIButton new];
    [_addTaskButton addTarget:self action:@selector(didClickAddTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateNormal];
    [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:_addTaskButton];
    [_addTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(@(-13.5));
    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else
        [self loadData];
    
    if (FIRST_LAUNCH_TASKDETAIL) {
        SKHelperGuideView *helperView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperGuideViewTypeTaskDetail];
        [KEY_WINDOW addSubview:helperView];
        EVER_LAUNCH_TASKDETAIL
    }
}

#pragma mark - Actions

- (void)didClickButton1:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene_highlight"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button1);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
        _scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)didClickButton2:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest_highlight"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button2);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
        _scrollView.contentOffset = CGPointMake(self.view.width, 0);
    }];
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickAddTaskButton:(UIButton *)sender {
    if (self.isAddTaskList) {
        [[[SKServiceManager sharedInstance] strongholdService] deleteTaskWithID:_detail.id];
    } else {
        [[[SKServiceManager sharedInstance] strongholdService] addTaskWithID:_detail.id];
    }
    self.isAddTaskList = !self.isAddTaskList;
    [self showTipsWith:_isAddTaskList];
}

- (void)showTipsWith:(BOOL)flag {
    UIView *_tipsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.width, 64)];
    [self.view addSubview:_tipsBackView];
    _tipsBackView.backgroundColor = COMMON_GREEN_COLOR;
    
    UIImageView *imageView;
    if (flag) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_addtask"]];
//        [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateNormal];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskpage_canceltask"]];
//        [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateNormal];
    }
    [_tipsBackView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tipsBackView.mas_centerX);
        make.centerY.equalTo(_tipsBackView.mas_centerY);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        _tipsBackView.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:1.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _tipsBackView.top = -64;
                         }
                         completion:^(BOOL finished) {
                             [_tipsBackView removeFromSuperview];
                         }];
    }];

}

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller reward:(SKReward *)reward {
    [controller dismissViewControllerAnimated:NO
                                   completion:^{
                                       [self removeDimmingView];
                                       [self showRewardViewWithReward:reward];
                                       [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
                                   }];
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isAddTaskList"]) {
        if (self.isAddTaskList) {
            [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateNormal];
            [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateHighlighted];
        } else {
            [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask"] forState:UIControlStateNormal];
            [_addTaskButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_addtask_highlight"] forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - Actions

- (void)didClickScanningButton:(UIButton *)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice
                                        authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        HTAlertView *alertView =
        [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
        [alertView show];
    } else {
        HTARCaptureController *controller = [[HTARCaptureController alloc] initWithStronghold:_detail];
        controller.delegate = self;
        [self presentViewController:controller animated:NO completion:nil];
    }
}

- (void)removeDimmingView {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
}

- (void)showRewardViewWithReward:(SKReward *)reward {
    NZQuestionFullScreenGiftView *rewardView = [[NZQuestionFullScreenGiftView alloc] initWithFrame:self.view.bounds withReward:reward withCityCode:self.cityCode];
    [self.view addSubview:rewardView];
}

@end
