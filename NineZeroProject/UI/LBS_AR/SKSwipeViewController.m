//
//  SKSwipeViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKSwipeViewController.h"
#import "HTUIHeader.h"
#import "NZPScanningFileDownloadManager.h"
#import "SKDownloadProgressView.h"
#import "SKPopupGetPuzzleView.h"
#import "SKScanningImageView.h"
#import "SKScanningPuzzleView.h"
#import "SKScanningPuzzleView.h"
#import "SKScanningRewardViewController.h"
#import <SSZipArchive/ZipArchive.h>
#import <TTTAttributedLabel.h>

@interface SKSwipeViewController () <OpenGLViewDelegate, SKScanningRewardDelegate, SKScanningImageViewDelegate, SKScanningPuzzleViewDelegate, SKPopupGetPuzzleViewDelegate>

@property (nonatomic, strong) SKScanningImageView *scanningImageView;
@property (nonatomic, strong) SKScanningPuzzleView *scanningPuzzleView;

@property (nonatomic, strong) SKScanningRewardViewController *scanningRewardViewController;

@property (nonatomic, strong) SKDownloadProgressView *progressView;

@property (nonatomic, strong) UIButton *hintButton;
@property (nonatomic, strong) UIView *hintView;

@property (nonatomic, strong) UIButton *hintGuideImageView;

@property (nonatomic, strong) NSMutableArray *rewardAction;
@property (nonatomic, strong) NSArray *rewardID;
@property (nonatomic, assign) SKScanType swipeType; // default is SKScanTypeImage
@property (nonatomic, strong) NSMutableArray *isRecognizedTargetImage;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *sid; // 活动id
@property (nonatomic, copy) NSString *downloadKey;
@property (nonatomic, strong) NSArray *linkURLs; // 普通扫一扫存储video url，拼图扫一扫返回目标图URL
@property (nonatomic, strong) NSArray *linkClarity;
@property (nonatomic, strong) NSString *defaultPic;
@property (nonatomic, strong) SKReward *rewardRecord;

@end

@implementation SKSwipeViewController {
	NSUInteger _trackedTargetId;
}

- (instancetype)init {
	if (self = [super init]) {
		_swipeType = SKScanTypeImage;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	if (!NO_NETWORK) {
		[self loadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.glView stop];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self.glView resize:self.view.bounds orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.glView setOrientation:toInterfaceOrientation];
}

- (void)loadData {
	[[[SKServiceManager sharedInstance] scanningService] getAllScanningWithCallBack:^(BOOL success, SKResponsePackage *package) {
	    if (success) {
		    NSDictionary *data = package.data[0];
		    if (!data && ![data isKindOfClass:[NSDictionary class]]) {
			    [self.navigationController popViewControllerAnimated:YES];
			    return;
		    }

		    NSLog(@"data-->%@", data);
		    self.swipeType = [[data objectForKey:@"type"] integerValue];
		    self.downloadKey = [data objectForKey:@"file_url"];
		    self.linkURLs = [data objectForKey:@"link_url"];
		    self.rewardID = [data objectForKey:@"reward_id"];
		    self.rewardAction = [[data objectForKey:@"reward_action"] mutableCopy];
		    self.hint = [data objectForKey:@"hint"];
		    self.sid = [data objectForKey:@"sid"];
		    self.linkClarity = [data objectForKey:@"link_clarity"];
		    self.defaultPic = [data objectForKey:@"default_pic"];

		    self.rewardRecord = [SKReward mj_objectWithKeyValues:[data objectForKey:@"reward_record"]];

		    __weak __typeof__(self) weakSelf = self;
		    [self setupScanningFile:data
			    completionHandler:^{
				__strong __typeof__(self) strongSelf = weakSelf;
				switch (_swipeType) {
					case SKScanTypeImage: {
						strongSelf.scanningImageView = [[SKScanningImageView alloc] initWithFrame:self.view.frame];
						strongSelf.scanningImageView.delegate = strongSelf;
						[strongSelf.view insertSubview:strongSelf.scanningImageView atIndex:1];

						break;
					}
					case SKScanTypePuzzle: {
						strongSelf.scanningPuzzleView = [[SKScanningPuzzleView alloc] initWithLinkClarity:strongSelf.linkClarity rewardAction:strongSelf.rewardAction defaultPic:strongSelf.defaultPic];
						strongSelf.scanningPuzzleView.delegate = strongSelf;
						[strongSelf.view insertSubview:strongSelf.scanningPuzzleView atIndex:1];
						break;
					}
					default:
						break;
				}
			    }];
	    } else {
		    [self.navigationController popViewControllerAnimated:YES];
	    }
	}];
}

- (void)setupScanningFile:(NSDictionary *)data completionHandler:(void (^)())completionHandler {
	if (_hint && _hint.length > 0) {
		[self setupHintButton];
	}

	NSMutableArray *array = [NSMutableArray arrayWithCapacity:_rewardAction.count];
	for (int i = 0; i < _rewardAction.count; i++) {
		[array addObject:[NSNumber numberWithBool:false]];
	}
	self.isRecognizedTargetImage = array;

	if (![NZPScanningFileDownloadManager isZipFileExistsWithFileName:_downloadKey]) {
		// 文件不存在，需要下载
		[self setupProgressView];

		[NZPScanningFileDownloadManager downloadZip:_downloadKey
			progress:^(NSProgress *downloadProgress) {
			    // 更新进度条
			    dispatch_async(dispatch_get_main_queue(), ^{
				[self.progressView setProgressViewPercent:downloadProgress.fractionCompleted];
			    });
			}
			completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			    if (!error) {
				    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
				    NSURL *unzipFilesPath = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
				    unzipFilesPath = [unzipFilesPath URLByAppendingPathComponent:fileName];

				    [SSZipArchive unzipFileAtPath:filePath.relativePath
					    toDestination:unzipFilesPath.relativePath
					    overwrite:YES
					    password:nil
					    progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
					    }
					    completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error) {
						dispatch_async(dispatch_get_main_queue(), ^{
						    [self.progressView removeFromSuperview];
						    self.progressView = nil;
						});
						if (succeeded) {
							// 加载识别图
							[self setupOpenGLViewWithTargetNumber:self.rewardAction.count];
							[self.glView startWithFileName:self.downloadKey videoURLs:self.linkURLs];
							completionHandler();
						} else {
							NSLog(@"zip解压失败:%@", error);
						}

					    }];
			    } else {
				    NSLog(@"识别图下载失败:%@", error);
			    }

			}];
	} else if (![NZPScanningFileDownloadManager isUnZipFileExistsWithFileName:_downloadKey]) {
		// zip已下载但是解压文件不存在
		NSString *unzipFilePath = [[_downloadKey lastPathComponent] stringByDeletingPathExtension];
		NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
		unzipFilePath = [documentsDirectoryURL URLByAppendingPathComponent:unzipFilePath].relativePath;
		NSString *zipFileAtPath = [documentsDirectoryURL URLByAppendingPathComponent:_downloadKey].relativePath;

		[SSZipArchive unzipFileAtPath:zipFileAtPath
			toDestination:unzipFilePath
			overwrite:YES
			password:nil
			progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {

			}
			completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error) {
			    // 加载识别图
			    [self setupOpenGLViewWithTargetNumber:self.linkURLs.count];
			    [self.glView startWithFileName:self.downloadKey videoURLs:self.linkURLs];
			    completionHandler();
			}];
	} else {
		// 直接加载识别图
		[self setupOpenGLViewWithTargetNumber:_linkURLs.count];
		[self.glView startWithFileName:_downloadKey videoURLs:_linkURLs];
		completionHandler();
	}
}

- (void)setupOpenGLViewWithTargetNumber:(NSUInteger)targetNumber {
	if (!_glView) {
		self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds withSwipeType:_swipeType targetsCount:(int)targetNumber];
		self.glView.delegate = self;
		[self.view insertSubview:_glView atIndex:0];
		[self.glView setOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	}
}

- (void)setupProgressView {
	//进度条
	_progressView = [[SKDownloadProgressView alloc] init];
	_progressView.center = self.view.center;
	[self.view addSubview:_progressView];
}

- (void)setupHintButton {
	if (FIRST_LAUNCH_SWIPEVIEW) {
		_hintButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
		_hintButton.right = self.view.right - 4.f;
		_hintButton.top = self.view.top + 12.f;
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule"] forState:UIControlStateNormal];
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule_highlight"] forState:UIControlStateHighlighted];
		[_hintButton addTarget:self action:@selector(showHintView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintButton];

		_hintGuideImageView = [[UIButton alloc] initWithFrame:self.view.frame];

		UIImage *backgroundImage;
		if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_640"];
		} else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_750"];
		} else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
			backgroundImage = [UIImage imageNamed:@"coach_scanning_mark_1242"];
		}

		[_hintGuideImageView setImage:backgroundImage forState:UIControlStateNormal];
		[_hintGuideImageView addTarget:self action:@selector(hideHintGuideView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintGuideImageView];
		_hintGuideImageView.alpha = 0;

		UILabel *hintGuideLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12.5f)];
		hintGuideLabel.text = @"点击任意区域关闭";
		hintGuideLabel.textAlignment = NSTextAlignmentCenter;
		hintGuideLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
		hintGuideLabel.font = PINGFANG_FONT_OF_SIZE(12.f);
		hintGuideLabel.alpha = 0;
		hintGuideLabel.bottom = self.view.bottom - 16.f;
		hintGuideLabel.centerX = self.view.centerX;
		[_hintGuideImageView addSubview:hintGuideLabel];

		[UIView animateWithDuration:0.5f
				 animations:^{
				     _hintGuideImageView.alpha = 1.0f;
				     hintGuideLabel.alpha = 1.0f;
				 }];

		LAUNCHED_SWIPEVIEW
	} else {
		_hintButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
		_hintButton.right = self.view.right - 4.f;
		_hintButton.top = self.view.top + 12.f;
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule"] forState:UIControlStateNormal];
		[_hintButton setImage:[UIImage imageNamed:@"btn_scanning_rule_highlight"] forState:UIControlStateHighlighted];
		[_hintButton addTarget:self action:@selector(showHintView) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:_hintButton];
	}
}

- (void)showHintView {
	[_glView pause];

	if (!_hintView) {
		_hintView = [[UIView alloc] initWithFrame:self.view.frame];
		[self.view addSubview:_hintView];

		CALayer *backGroundLayer = [[CALayer alloc] init];
		backGroundLayer.frame = SCREEN_BOUNDS;
		backGroundLayer.backgroundColor = [UIColor colorWithHex:0x000000].CGColor;
		backGroundLayer.opacity = 0.8;
		[_hintView.layer addSublayer:backGroundLayer];

		UIButton *closeButton = [[UIButton alloc] init];
		[closeButton addTarget:self action:@selector(hideHintView) forControlEvents:UIControlEventTouchDown];
		[closeButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
		[_hintView addSubview:closeButton];
		[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@40);
		    make.height.equalTo(@40);
		    make.top.equalTo(@12);
		    make.left.equalTo(@4);
		}];

		TTTAttributedLabel *hintLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(40.f, 0, SCREEN_WIDTH - 80, 0)];
		hintLabel.textAlignment = NSTextAlignmentLeft;
		hintLabel.numberOfLines = 0;
		hintLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
		hintLabel.font = PINGFANG_FONT_OF_SIZE(10.0);
		hintLabel.lineSpacing = 2.0f;
		hintLabel.text = _hint;
		[_hintView addSubview:hintLabel];
		[hintLabel sizeToFit];

		hintLabel.centerY = self.view.centerY;

		CALayer *hintImageLayer = [[CALayer alloc] init];
		hintImageLayer.frame = CGRectMake((SCREEN_WIDTH - 253) / 2.f, hintLabel.top - 92.f - 20.f, 253, 92);
		hintImageLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"img_scanning_rule"].CGImage);
		[_hintView.layer addSublayer:hintImageLayer];

		CALayer *hintBackGroundLayer = [[CALayer alloc] init];
		hintBackGroundLayer.frame = CGRectMake(20.f, hintLabel.frame.origin.y - 57.f, SCREEN_WIDTH - 40.f, hintLabel.height + 20.f + 20.f + 35.f);
		hintBackGroundLayer.backgroundColor = [UIColor colorWithHex:0x1F1F1F].CGColor;
		hintBackGroundLayer.cornerRadius = 5;
		hintBackGroundLayer.shouldRasterize = YES;
		[_hintView.layer insertSublayer:hintBackGroundLayer below:hintLabel.layer];
	}

	_hintView.alpha = 0;

	[UIView animateWithDuration:0.5f
			 animations:^{
			     _hintView.alpha = 1.0f;
			 }];
}

- (void)hideHintGuideView {
	[_hintGuideImageView removeFromSuperview];
	_hintGuideImageView = nil;
}

- (void)hideHintView {
	[UIView animateWithDuration:0.5f
		animations:^{
		    _hintView.alpha = 0;
		}
		completion:^(BOOL finished) {
		    [_hintView removeFromSuperview];
		    _hintView = nil;
		    [_glView restart];
		}];
}

- (void)onCaptureMascotSuccessful {
	[self.delegate didClickBackButtonInScanningResultView:self];
}

#pragma SKScanningImageViewDelegate

- (void)scanningImageView:(SKScanningImageView *)imageView didTapGiftButton:(id)giftButton {
	[imageView removeGiftView];
	SKScanningRewardViewController *controller = [[SKScanningRewardViewController alloc] initWithRewardID:[self.rewardID objectAtIndex:_trackedTargetId] sId:_sid scanType:_swipeType];
	controller.delegate = self;
	[self presentViewController:controller animated:NO completion:nil];
}

#pragma mark - OpenGLViewDelegate

- (void)isRecognizedTarget:(BOOL)flag targetId:(int)targetId {
	if (flag && targetId >= 0 && targetId < _isRecognizedTargetImage.count) {
		if (_swipeType == SKScanTypeImage) {
			if (![[_isRecognizedTargetImage objectAtIndex:targetId] boolValue]) {
				if (_rewardID && ![[_rewardID objectAtIndex:targetId] isEqualToString:@"0"] && [[_rewardAction objectAtIndex:targetId] isEqualToString:@"0"]) {
					_trackedTargetId = targetId;
					[self.scanningImageView.scanningGridLine setHidden:YES];
					[_scanningImageView setUpGiftView];
					[_scanningImageView pushGift];
				}
				_isRecognizedTargetImage[targetId] = [NSNumber numberWithBool:true];
			}
		} else {
			if (![[_isRecognizedTargetImage objectAtIndex:targetId] boolValue]) {
				if (_rewardID && [[_rewardAction objectAtIndex:targetId] isEqualToString:@"0"]) {
					[_scanningPuzzleView hidePuzzleButton];
					[_scanningPuzzleView hideAnimationView];
					_trackedTargetId = targetId;
					[_glView pause];
					[_scanningPuzzleView showBoxView];
				}

				_isRecognizedTargetImage[targetId] = [NSNumber numberWithBool:true];
			}
		}
	} else {
		if (_swipeType == SKScanTypeImage) {
			[self.scanningImageView showScanningGridLine];
		}
	}
}

#pragma mark - SKScanningRewardDelegate
- (void)didClickBackButtonInScanningCaptureController:(SKScanningRewardViewController *)controller {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SKScanningPuzzleViewDelegate
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapExchangeButton:(UIButton *)button {
	// 兑换
	_scanningRewardViewController = [[SKScanningRewardViewController alloc] initWithRewardID:[self.rewardID firstObject] sId:_sid scanType:_swipeType];
	_scanningRewardViewController.delegate = self;
	[self.view addSubview:_scanningRewardViewController.view];
}

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapBoxButton:(UIButton *)button {
	// 点开宝箱
	[_scanningPuzzleView hideBoxView];

	[[[SKServiceManager sharedInstance] scanningService] getScanningPuzzleWithMontageId:[_linkURLs objectAtIndex:_trackedTargetId]
											sId:_sid
										   callback:^(BOOL success, SKResponsePackage *response) {
										       NSLog(@"%@", response);
										       if (success && response.result == 0) {
											       SKPopupGetPuzzleView *puzzleView = [[SKPopupGetPuzzleView alloc] initWithPuzzleImageURL:[_linkURLs objectAtIndex:_trackedTargetId]];
											       puzzleView.delegate = self;
											       [self.view addSubview:puzzleView];

											       _rewardAction[_trackedTargetId] = @"1";

										       } else {
											       NSLog(@"获取拼图碎片失败");
											       [_glView restart];
											       [_scanningPuzzleView showAnimationView];
											       [_scanningPuzzleView showPuzzleButton];
										       }
										   }];
}

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view isShowPuzzles:(BOOL)isShowPuzzles {
	if (isShowPuzzles) {
		[_glView pause];
	} else {
		[_glView restart];
	}

	if (!_rewardRecord) {
		[_scanningPuzzleView setupPuzzleView];
	} else {
		[_scanningPuzzleView hideAnimationView];
		[_scanningPuzzleView hidePuzzleButton];

		_scanningRewardViewController = [[SKScanningRewardViewController alloc] initWithReward:_rewardRecord];
		_scanningRewardViewController.delegate = self;
		[self.view addSubview:_scanningRewardViewController.view];
	}
}

#pragma mark SKPopupGetPuzzleViewDelegate
- (void)didRemoveFromSuperView {
	[_glView restart];
	[_scanningPuzzleView showAnimationView];
	[_scanningPuzzleView showPuzzleButton];
}

@end
