//
//  SKMyBadgesViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMyBadgesViewController.h"
#import "HTUIHeader.h"

#import "SKDescriptionView.h"

@interface SKBadgeCell: UITableViewCell
@property (nonatomic, strong) SKBadge     *badgeLeft;
@property (nonatomic, strong) SKBadge     *badgeRight;
@property (nonatomic, strong) UIImageView *badgeLeftImageView;
@property (nonatomic, strong) UIImageView *badgeLeftShadowImageView;
@property (nonatomic, strong) UIImageView *badgeRightImageView;
@property (nonatomic, strong) UIImageView *badgeRightShadowImageView;

@property (nonatomic, strong) UIButton    *leftbutton;
@property (nonatomic, strong) UIButton    *rightbutton;
@end

@implementation SKBadgeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = COMMON_SEPARATOR_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *headBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        headBar.backgroundColor = [UIColor colorWithHex:0x242424];
        [self.contentView addSubview:headBar];
        
        UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, ROUND_HEIGHT_FLOAT(154)-4-25, SCREEN_WIDTH, 25)];
        footBar.backgroundColor = [UIColor colorWithHex:0x242424];
        [self.contentView addSubview:footBar];
        UIView *footBar2 = [[UIView alloc] initWithFrame:CGRectMake(0, ROUND_HEIGHT_FLOAT(154)-4, SCREEN_WIDTH, 4)];
        footBar2.backgroundColor = COMMON_BG_COLOR;
        [self.contentView addSubview:footBar2];
        
        _badgeLeftShadowImageView = [[UIImageView alloc] init];
        [self addSubview:_badgeLeftShadowImageView];
        _badgeRightShadowImageView = [[UIImageView alloc] init];
        [self addSubview:_badgeRightShadowImageView];
        
        [_badgeLeftShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ROUND_WIDTH(120));
            make.height.mas_equalTo(ROUND_WIDTH_FLOAT(120)/120*99);
            make.left.equalTo(ROUND_WIDTH(22));
            make.bottom.equalTo(self.mas_bottom).offset(-14);
        }];
        [_badgeRightShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_badgeLeftShadowImageView.mas_width);
            make.height.equalTo(_badgeLeftShadowImageView.mas_height);
            make.right.equalTo(self.mas_right).offset(ROUND_WIDTH_FLOAT(-22));
            make.bottom.equalTo(self.mas_bottom).offset(-14);
        }];
        
        _badgeLeftImageView = [[UIImageView alloc] init];
        [self addSubview:_badgeLeftImageView];
        _badgeRightImageView = [[UIImageView alloc] init];
        [self addSubview:_badgeRightImageView];
        
        [_badgeLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ROUND_WIDTH(120));
            make.height.mas_equalTo(ROUND_WIDTH_FLOAT(120)/120*99);
            make.left.equalTo(ROUND_WIDTH(22));
            make.bottom.equalTo(self.mas_bottom).offset(-14);
        }];
        [_badgeRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_badgeLeftImageView.mas_width);
            make.height.equalTo(_badgeLeftImageView.mas_height);
            make.right.equalTo(self.mas_right).offset(ROUND_WIDTH_FLOAT(-22));
            make.bottom.equalTo(self.mas_bottom).offset(-14);
        }];
        
        _leftbutton = [UIButton new];
        [_leftbutton addTarget:self action:@selector(leftImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftbutton];
        [_leftbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_badgeLeftImageView);
            make.center.equalTo(_badgeLeftImageView);
        }];
        
        _rightbutton = [UIButton new];
        [_rightbutton addTarget:self action:@selector(rightImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightbutton];
        [_rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_badgeRightImageView);
            make.center.equalTo(_badgeRightImageView);
        }];

    }
    return self;
}

- (void)leftImageClick {
    SKDescriptionView *descriptionView = [[SKDescriptionView alloc] initWithURLString:self.badgeLeft.medal_description andType:SKDescriptionTypeBadge andImageUrl:self.badgeLeft.medal_pic];
    [[self viewController].view addSubview:descriptionView];
    [descriptionView showAnimated];
}

- (void)rightImageClick {
    SKDescriptionView *descriptionView = [[SKDescriptionView alloc] initWithURLString:self.badgeRight.medal_description andType:SKDescriptionTypeBadge andImageUrl:self.badgeRight.medal_pic];
    [[self viewController].view addSubview:descriptionView];
    [descriptionView showAnimated];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end



@interface SKMyBadgesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSArray<SKBadge*> *badgeArray;
@property (nonatomic, assign) NSInteger         exp;
@property (nonatomic, assign) NSInteger         badgeLevel;

@property (nonatomic, strong) UILabel *expLabel;
@property (nonatomic, strong) SKProfileProgressView *progressView;
@end

@implementation SKMyBadgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getBadges:^(BOOL success, NSInteger exp, NSArray<SKBadge *> *badges) {
        self.badgeArray = badges;
        self.exp = exp;
        
        NSMutableArray *badgeLevels = [NSMutableArray array];
        [badgeLevels addObject:@(-1)];
        for (SKBadge *badge in badges) {
            [badgeLevels addObject:[NSNumber numberWithInteger:[badge.medal_level integerValue]]];
        }
        [UD setObject:[badgeLevels copy] forKey:kBadgeLevels];
        _badgeLevel = [self badgeLevel];
        if (_badgeLevel == 1) {
            NSInteger targetLevel = [[[UD objectForKey:kBadgeLevels] objectAtIndex:_badgeLevel] floatValue];
            _expLabel.text = [NSString stringWithFormat:@"%ld", (targetLevel-self.exp)];
            [_progressView setProgress:((float)self.exp)/targetLevel];
        } else if (_badgeLevel>1) {
            NSInteger targetLevel = [[[UD objectForKey:kBadgeLevels] objectAtIndex:_badgeLevel] floatValue];
            _expLabel.text = [NSString stringWithFormat:@"%ld", (targetLevel-self.exp)];
            [_progressView setProgress:(self.exp-[[[UD objectForKey:kBadgeLevels] objectAtIndex:_badgeLevel-1] floatValue])/(targetLevel-[[[UD objectForKey:kBadgeLevels] objectAtIndex:_badgeLevel-1] floatValue])];
        } else {
            _expLabel.text = @"0";
            [_progressView setProgress:1.0];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SKBadgeCell class] forCellReuseIdentifier:NSStringFromClass([SKBadgeCell class])];
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162)];
    headerView.backgroundColor = [UIColor blackColor];
    self.tableView.tableHeaderView = headerView;
    
    UILabel *myBadgeTitleLabel = [UILabel new];
    myBadgeTitleLabel.text = @"我的勋章";
    myBadgeTitleLabel.textColor = [UIColor whiteColor];
    myBadgeTitleLabel.font = PINGFANG_FONT_OF_SIZE(20);
    [myBadgeTitleLabel sizeToFit];
    [headerView addSubview:myBadgeTitleLabel];
    
    UIImageView *nextBadgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exptext"]];
    [nextBadgeImageView sizeToFit];
    [headerView addSubview:nextBadgeImageView];
    
    UIImageView *expArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exp"]];
    [expArrowImageView sizeToFit];
    [headerView addSubview:expArrowImageView];
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mymedal_medal"]];
    [badgeImageView sizeToFit];
    [headerView addSubview:badgeImageView];
    
    _progressView = [[SKProfileProgressView alloc] initWithFrame:CGRectZero];
    [_progressView setProgress:0];
    [_progressView setBackColor:[UIColor colorWithHex:0x1f1f1f]];
    [_progressView setCoverColor:[UIColor colorWithHex:0xfdd900]];
    [headerView addSubview:_progressView];
    
    _expLabel = [UILabel new];
    _expLabel.text = @"0";
    _expLabel.textColor = [UIColor colorWithHex:0xffed41];
    _expLabel.font = MOON_FONT_OF_SIZE(12);
    [_expLabel sizeToFit];
    [headerView addSubview:_expLabel];
    
    [myBadgeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView);
        make.bottom.equalTo(nextBadgeImageView.mas_top).offset(-11);
        make.top.equalTo(@68);
    }];
    
    [nextBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_progressView).offset(10);
        make.bottom.equalTo(_progressView.mas_top).offset(-9);
    }];

    [expArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(nextBadgeImageView.mas_right).offset(2);
    }];
    
    [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(expArrowImageView.mas_right).offset(5);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.width.equalTo(@166);
        make.height.equalTo(@16);
    }];
    
    [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.right.equalTo(headerView);
    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:blankView];
        blankView.top = ROUND_HEIGHT_FLOAT(217);
    } else
        [self loadData];
}

- (NSInteger)badgeLevel {
    __block NSInteger badgeLevel = -1;
    DLog(@"%@", (NSArray*)[UD objectForKey:kBadgeLevels]);
    [[UD objectForKey:kBadgeLevels] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Exp:%ld Target%ld", (long)self.exp, (long)[obj integerValue]);
        if (self.exp < [obj integerValue]) {
            badgeLevel = idx;
            *stop = YES;
        }
    }];
    return badgeLevel;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKBadgeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKBadgeCell class]) forIndexPath:indexPath];
    cell.badgeLeft = self.badgeArray[indexPath.row*2];
    if (self.badgeArray.count-1>=indexPath.row*2+1) {
        cell.badgeRight = self.badgeArray[indexPath.row*2+1];
    }
    
    cell.badgeLeftShadowImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_badge_shadow_%ld", indexPath.row*2]];
    cell.badgeRightShadowImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_badge_shadow_%ld", indexPath.row*2+1]];
    
    [cell.badgeLeftImageView sd_setImageWithURL:[NSURL URLWithString:self.badgeArray[indexPath.row*2].medal_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (_badgeLevel>0 && _badgeLevel-1<indexPath.row*2+1) {
            cell.badgeLeftImageView.alpha = 0.4;
            cell.leftbutton.enabled = NO;
        }
    }];
    
    [cell.badgeRightImageView sd_setImageWithURL:[NSURL URLWithString:self.badgeArray[indexPath.row*2+1].medal_icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (_badgeLevel>0 && _badgeLevel-1<indexPath.row*2+2) {
            cell.badgeRightImageView.alpha = 0.4;
            cell.rightbutton.enabled = NO;
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_HEIGHT_FLOAT(154);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)ceil(self.badgeArray.count/2.0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


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



@interface SKProfileProgressView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *coverColor;
@end

@implementation SKProfileProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithHex:0x232323];
        [self addSubview:_backView];
        
        _coverView = [[UIView alloc] init];
        [self addSubview:_coverView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsLayout];
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    _coverView.backgroundColor = coverColor;
}

- (void)setBackColor:(UIColor *)backColor {
    _backView.backgroundColor = backColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backView.layer.cornerRadius = 8.0f;
    _coverView.layer.cornerRadius = 8.0f;
    _backView.frame = CGRectMake(0, 0, self.width, self.height);
    _coverView.frame = CGRectMake(0, 0, self.width * MAX(0 ,MIN(_progress, 1)), self.height);
}

@end


