//
//  SKScanningResultView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/10.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKScanningResultView.h"
#import "HTUIHeader.h"

@interface SKScanningResultView ()

@property (nonatomic, assign) NSUInteger    index;
@property (nonatomic, strong) UIImageView   *scanningImageView;
@property (strong, nonatomic) AVPlayer      *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem  *playerItem;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation SKScanningResultView

- (instancetype)initWithFrame:(CGRect)frame withIndex:(NSUInteger)index{
    if (self = [super initWithFrame:frame]) {
        _index = index;
        [self loadData];
    }
    return self;
}

- (void)loadData {
    [[[HTServiceManager sharedInstance] questionService] getScanning:^(BOOL success, NSArray<HTScanning *> *scanningList) {
        HTScanning *scanning = scanningList[_index];
        DLog(@"Scanning Type:%@", scanning.link_type);
        if ([scanning.link_type isEqualToString:@"0"] ) {
            [self createVideoWithUrlString:scanning.link_url];
        } else if ([scanning.link_type isEqualToString:@"1"] || [scanning.link_type isEqualToString:@"2"]) {
            [self createImageWithUrlString:scanning.link_url];
        }
    }];
}

- (void)createVideoWithUrlString:(NSString*)urlString {
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"trailer_video" ofType:@"mp4"];
    NSString *fileName = [[urlString componentsSeparatedByString:@"/"] lastObject];
    _playerLayer.frame = CGRectMake(0, 0, self.width, self.height);
    // 本地沙盒目录
    //NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectoryURL path]]) {
        NSURL *localUrl = [NSURL fileURLWithPath:[documentsDirectoryURL path]];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
        _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, self.width, self.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer insertSublayer:_playerLayer atIndex:0];
        
        [_player play];
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        [_downloadTask cancel];
        _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            _playerItem = nil;
            _player = nil;
            [_playerLayer removeFromSuperlayer];
            _playerLayer = nil;
            if (filePath == nil) return;
            NSURL *localUrl = [NSURL fileURLWithPath:[filePath path]];
            AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
            self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
            self.player = [AVPlayer playerWithPlayerItem:_playerItem];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.videoGravity = AVLayerVideoGravityResize;
            [self setNeedsLayout];
            [_player play];
        }];
        [_downloadTask resume];
    }
}

- (void)createImageWithUrlString:(NSString*)urlString {
    _scanningImageView = [[UIImageView alloc] init];
    _scanningImageView.frame = self.frame;
    _scanningImageView.contentMode = UIViewContentModeScaleAspectFit;
    _scanningImageView.layer.masksToBounds = YES;
    [self addSubview:_scanningImageView];
    [_scanningImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _scanningImageView.centerX = SCREEN_WIDTH/2;
        _scanningImageView.centerY = SCREEN_HEIGHT/2;
    }];
    
}

@end
