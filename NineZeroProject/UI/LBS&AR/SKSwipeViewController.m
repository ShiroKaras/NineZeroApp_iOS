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
#import "SKScanningResultView.h"
#import <SSZipArchive/ZipArchive.h>

@interface SKSwipeViewController ()

@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *scanningGridLine;
//@property (nonatomic, strong) NSArray<SKScanning*>* scanningList;
@property (nonatomic, strong) SKQuestion *question;
@property (nonatomic, assign) int swipeType;
@property (nonatomic, strong) SKDownloadProgressView *progressView;

@end

@implementation SKSwipeViewController

- (instancetype)init {
	if (self = [super init]) {
		_swipeType = 0;
	}
	return self;
}

- (instancetype)initWithQuestion:(SKQuestion *)question {
	self = [super init];
	if (self) {
		_swipeType = 1;
		_question = question;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	//扫描线
	_scanningGridLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_gridlines"]];
	[_scanningGridLine sizeToFit];
	_scanningGridLine.top = 0;
	_scanningGridLine.right = 0;
	[self.view addSubview:_scanningGridLine];

	[UIView animateWithDuration:1.0
		animations:^{
		    _scanningGridLine.left = SCREEN_WIDTH;
		}
		completion:^(BOOL finished) {
		    _scanningGridLine.right = 0;
		    _scanningGridLine.alpha = 0.4;
		    [UIView animateWithDuration:1.0
			    animations:^{
				_scanningGridLine.left = SCREEN_WIDTH;
			    }
			    completion:^(BOOL finished) {
				[_scanningGridLine removeFromSuperview];
			    }];
		}];

	if (!NO_NETWORK) {
		[self loadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.glView stop];
	for (UIView *view in KEY_WINDOW.subviews) {
		if ([view isKindOfClass:[SKScanningResultView class]]) {
			[view removeFromSuperview];
		}
	}
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self.glView resize:self.view.bounds orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.glView setOrientation:toInterfaceOrientation];
}

- (void)buildConstrains {
	[self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.bottom.equalTo(@(-55));
	    make.centerX.equalTo(self.view);
	    make.width.equalTo(@(288));
	    make.height.equalTo(@(86));
	}];

	[self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(self.tipImageView);
	    make.bottom.equalTo(self.tipImageView.mas_bottom).offset(-27);
	}];
}

- (void)loadData {
	[[[SKServiceManager sharedInstance] scanningService] getScanningWithCallBack:^(BOOL success, SKResponsePackage *package) {
	    if (success) {
		    // 获取zip下载地址
		    NSDictionary *dic = package.data[0];
		    __block NSString *downloadKey = [dic objectForKey:@"file_url"];
		    __block NSArray *videoURLs = [dic objectForKey:@"link_url"];

		    NSString *hint = [dic objectForKey:@"hint"];
		    if (hint && hint.length > 0) {
			    dispatch_async(dispatch_get_main_queue(), ^{
				[self setupTips];
				self.tipLabel.text = hint;
			    });
		    }

		    if (![NZPScanningFileDownloadManager isZipFileExistsWithFileName:downloadKey]) {
			    // 文件不存在，需要下载
			    [self setupProgressView];

			    [NZPScanningFileDownloadManager downloadZip:downloadKey
				    progress:^(NSProgress *downloadProgress) {
					// 更新进度条
					dispatch_async(dispatch_get_main_queue(), ^{
					    [_progressView setProgressViewPercent:downloadProgress.fractionCompleted];
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
								[_progressView removeFromSuperview];
								_progressView = nil;
							    });
							    if (succeeded) {
								    // 加载识别图
								    [self setupOpenGLViewWithTargetNumber:videoURLs.count];
								    [self.glView startWithFileName:downloadKey videoURLs:videoURLs];
							    } else {
								    NSLog(@"zip解压失败:%@", error);
							    }

							}];
					} else {
						NSLog(@"识别图下载失败:%@", error);
					}

				    }];
		    } else if (![NZPScanningFileDownloadManager isUnZipFileExistsWithFileName:downloadKey]) {
			    // zip已下载但是解压文件不存在
			    NSString *unzipFilePath = [[downloadKey lastPathComponent] stringByDeletingPathExtension];
			    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
			    unzipFilePath = [documentsDirectoryURL URLByAppendingPathComponent:unzipFilePath].relativePath;
			    NSString *zipFileAtPath = [documentsDirectoryURL URLByAppendingPathComponent:downloadKey].relativePath;

			    [SSZipArchive unzipFileAtPath:zipFileAtPath
				    toDestination:unzipFilePath
				    overwrite:YES
				    password:nil
				    progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {

				    }
				    completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nonnull error) {
					// 加载识别图
					[self setupOpenGLViewWithTargetNumber:videoURLs.count];
					[self.glView startWithFileName:downloadKey videoURLs:videoURLs];
				    }];
		    } else {
			    // 直接加载识别图
			    [self setupOpenGLViewWithTargetNumber:videoURLs.count];
			    [self.glView startWithFileName:downloadKey videoURLs:videoURLs];
		    }
	    } else {
		    // 获取AR活动信息失败
		    NSLog(@"获取AR信息失败");
	    }
	}];
}

- (void)setupOpenGLViewWithTargetNumber:(NSUInteger)targetNumber {
	if (!_glView) {
		self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds withSwipeType:_swipeType targetsCount:(int)targetNumber];
		[self.view addSubview:self.glView];
		[self.glView setOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	}
}
- (void)setupTips {
	//提示
	self.tipImageView = [[UIImageView alloc] init];
	self.tipImageView.layer.masksToBounds = YES;
	self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
	self.tipImageView.contentMode = UIViewContentModeBottom;
	[self.tipImageView sizeToFit];
	[self.view addSubview:self.tipImageView];
	self.tipLabel = [[UILabel alloc] init];
	if (_swipeType == 0) {
	} else if (_swipeType == 1) {
		self.tipLabel.text = _question.hint;
	}
	self.tipLabel.font = [UIFont systemFontOfSize:13];
	self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
	[self.tipImageView addSubview:self.tipLabel];
	[self showtipImageView];

	[self buildConstrains];
}

- (void)setupProgressView {
	//进度条
	_progressView = [[SKDownloadProgressView alloc] init];
	_progressView.center = self.view.center;
	[self.view addSubview:_progressView];
}

#pragma mark - Delegate

- (void)onCaptureMascotSuccessful {
	[self.delegate didClickBackButtonInScanningResultView:self];
}

#pragma mark - Actions

- (void)showtipImageView {
	self.tipImageView.alpha = 1.0;
	[UIView animateWithDuration:0.3
			      delay:10.0
			    options:UIViewAnimationOptionCurveEaseInOut
			 animations:^{
			     self.tipImageView.alpha = 0;
			 }
			 completion:^(BOOL finished){

			 }];
	//    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hidetipImageView) userInfo:nil repeats:NO];
}

- (void)hidetipImageView {
	[UIView animateWithDuration:0.3
			 animations:^{
			     self.tipImageView.alpha = 0;
			 }];
}
@end
