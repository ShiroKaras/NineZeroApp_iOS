//
//  SKAllQuestionViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKAllQuestionViewController.h"
#import "SKHelperView.h"

#define PAGE_COUNT (ceil(self.questionList.count/12.))

@interface SKAllQuestionViewController ()<UIScrollViewDelegate, SKHelperScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *mScrollView;
@property(nonatomic, strong) UIPageControl *pageContrl;
@property(nonatomic, strong) UIButton *helpButton;

@end

@implementation SKAllQuestionViewController{
    UICollectionView *mCollectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
    NSMutableArray *dataArray = [[[[HTServiceManager sharedInstance] questionService] questionList] mutableCopy];
    if (!_isMonday) {
        [dataArray removeLastObject];
    }
    [self createUIWithData:dataArray];
    [TalkingData trackPageBegin:@"alllevelspage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"alllevelspage"];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //[self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    if (FIRST_LAUNCH_QUESTIONLIST) {
        [self helpButtonClick:nil];
        [UD setBool:YES forKey:@"firstLaunchQuestionList"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create UI
- (void)createUI {
    self.view.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    
    float scrollViewHeight = (ROUND_WIDTH_FLOAT(64)*4+ ROUND_HEIGHT_FLOAT(26)*4);
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, scrollViewHeight)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*PAGE_COUNT, scrollViewHeight);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    
    __weak __typeof(self)weakSelf = self;
    UIButton *cancelButton = [UIButton new];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-26);
    }];
    
    _helpButton = [UIButton new];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help"] forState:UIControlStateNormal];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help_highlight"] forState:UIControlStateHighlighted];
    [_helpButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_helpButton];
    
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.view).offset(10);
        make.left.equalTo(weakSelf.view).offset(10);
    }];
    
    _pageContrl = [[UIPageControl alloc] init];
    _pageContrl.numberOfPages = PAGE_COUNT;
    _pageContrl.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _pageContrl.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _pageContrl.userInteractionEnabled = NO;
    [self.view addSubview:_pageContrl];
}

- (void)loadData {
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        
    }];
}

- (void)createUIWithData:(NSArray<HTQuestion*>*)questionList {
    self.questionList = questionList;
    
    for (UIView *view in self.mScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int questionNumber=0; questionNumber<questionList.count; questionNumber++) {
        int pageNumber = floor(questionNumber/12);
        int itemInPage = questionNumber-pageNumber*12;
        int i = itemInPage%3;
        int j = floor(itemInPage/3);
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(ROUND_WIDTH_FLOAT(35)+SCREEN_WIDTH*pageNumber+i*ROUND_WIDTH_FLOAT(93), ROUND_WIDTH_FLOAT(90)*j, ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64))];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        NSURL *coverURL = ([questionList[questionNumber].thumbnail_pic isEqualToString:@""]||questionList[questionNumber].thumbnail_pic==nil)?[NSURL URLWithString:questionList[questionNumber].question_video_cover]: [NSURL URLWithString:questionList[questionNumber].thumbnail_pic];
        [coverImageView sd_setImageWithURL:coverURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            int type;
            if (questionList[questionNumber].is_answer || ![questionList[questionNumber].question_ar_location isEqualToString:@""])  type = 0;
            else    type = 1;
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                NSString* key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
                BOOL result = [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
                NSString* imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
                NSData* newData = [NSData dataWithContentsOfFile:imagePath];
                if (!result || !newData) {
                    BOOL imageIsPng = [[self typeForImageData:newData] isEqualToString:@"image/png"];
                    NSData* imageData = nil;
                    if (imageIsPng) {
                        imageData = UIImagePNGRepresentation(image);
                    }
                    else {
                        imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                    }
                    NSFileManager* _fileManager = [NSFileManager defaultManager];
                    if (imageData) {
                        [_fileManager removeItemAtPath:imagePath error:nil];
                        [_fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
                    }
                }
                newData = [NSData dataWithContentsOfFile:imagePath];
                UIImage* grayImage = nil;
                if (type == 0) {
                    grayImage = [UIImage imageWithData:newData];
                }else{
                    UIImage* newImage = [UIImage imageWithData:newData];
                    
                    grayImage = [self grayscale:newImage type:1];
                }
                coverImageView.image = grayImage;
            }];
        }];
        coverImageView.layer.cornerRadius = itemView.width/2;
        coverImageView.layer.masksToBounds = YES;
        [itemView addSubview:coverImageView];
        
        //按钮
        UIButton *mImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mImageButton.tag = questionNumber;
        [mImageButton addTarget:self action:@selector(questionSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        mImageButton.frame = CGRectMake(0, 0, itemView.width, itemView.height);
        if (questionList[questionNumber].is_answer) {
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed"] forState:UIControlStateNormal];
            [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_completed_highlight"] forState:UIControlStateHighlighted];
        } else {
            if (questionList[questionNumber].type == 0 ) {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_AR_highlight"] forState:UIControlStateHighlighted];
            } else {
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted"] forState:UIControlStateNormal];
                [mImageButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_uncompleted_highlight"] forState:UIControlStateHighlighted];
            }
        }
        [itemView addSubview:mImageButton];
        
        //关卡号
        UILabel *mQuestionNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemView.width, itemView.height)];
        mQuestionNumberLabel.textColor = [UIColor whiteColor];
        mQuestionNumberLabel.text = [NSString stringWithFormat:@"%d",questionNumber+1];
        mQuestionNumberLabel.textAlignment = NSTextAlignmentCenter;
        mQuestionNumberLabel.font = MOON_FONT_OF_SIZE(23);
        [itemView addSubview:mQuestionNumberLabel];
        
        [_mScrollView addSubview:itemView];
    }
    
    __weak __typeof(self)weakSelf = self;
    [_pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_mScrollView.mas_bottom).offset(42);
        make.height.equalTo(@(8));
    }];
}

- (void)updateUIWithData:(NSArray<HTQuestion*>*)questionList {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //得到图片移动相对原点的坐标
    CGPoint point=scrollView.contentOffset;
    //移动不能超过左边;
    //    if(point.x<0){
    //        point.x=0;
    //        scrollView.contentOffset=point;
    //    }
    //移动不能超过右边
    if(point.x>PAGE_COUNT*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*PAGE_COUNT;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    NSInteger index=round(point.x/(SCREEN_WIDTH));
    _pageContrl.currentPage=index;
}

#pragma mark - Actions

- (void)cancelButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)questionSelectButtonClick:(UIButton *)sender {
    
}

- (void)helpButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"backgroundtips"];
    SKHelperScrollView *helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeQuestion];
    helpView.delegate = self;
    helpView.scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT-356)/2, 0, 0);
    helpView.dimmingView.alpha = 0;
    [self.view addSubview:helpView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        helpView.dimmingView.alpha = 0.9;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - SKHelperScrollViewDelegate

- (void)didClickCompleteButton {
    [_helpButton setImage:[UIImage imageNamed:@"btn_help_highlight"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.075 animations:^{
        _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.075 animations:^{
            _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^{
                _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.075 animations:^{
                    _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                } completion:^(BOOL finished) {
                    [_helpButton setImage:[UIImage imageNamed:@"btn_help"] forState:UIControlStateNormal];
                }];
            }];
        }];
    }];
}

#pragma mark - HTPreviewCardController

#pragma mark - Tool
- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
            
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

- (UIImage*)grayscale:(UIImage*)anImage type:(int)type {
    CGImageRef imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}



@end
