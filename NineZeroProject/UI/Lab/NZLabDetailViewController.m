//
//  NZLabDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/21.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabDetailViewController.h"
#import "HTUIHeader.h"

#import "NZSubmitCommentViewController.h"

#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "NZLabDetialCollectionViewCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import "HTWebController.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <CommonCrypto/CommonDigest.h>

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

#define SHARE_URL(u) [NSString stringWithFormat:@"https://admin.90app.tv/Home/TopicArticle/topic_article_detail/topic_id/%@.html", (u)]

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
    HTButtonTypeReplay
};

@interface NZLabDetailViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *dimmingView;

@property (nonatomic, strong) NSString *topicID;
@property (nonatomic, strong) NSString *topicTitle;

//分享
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

@property (nonatomic, strong) SKTopicDetail *topicDetail;
@end

@implementation NZLabDetailViewController

- (instancetype)initWithTopicID:(NSString *)topicID title:(NSString *)title {
    self = [super init];
    if (self) {
        _topicID = topicID;
        _topicTitle = title;
        _topicTitle = [_topicTitle stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        _topicTitle = [_topicTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    return self;
}

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = self.view.width;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT-49) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[NZLabDetialCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)createUI {
//    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-49, self.view.width, 49)];
    bottomView.backgroundColor = COMMON_TITLE_BG_COLOR;
    [self.view addSubview:bottomView];
    
    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(@13.5);
    }];
    
    UIButton *shareButton = [UIButton new];
    [shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView).offset(-13.5);
    }];
    
    UIButton *submitButton = [UIButton new];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"btn_labdetailpage_comment"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"btn_labdetailpage_comment_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareButton);
        make.right.equalTo(shareButton.mas_left).offset(-25);
    }];

    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else {
        [self loadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] topicService] getTopicDetailWithID:_topicID callback:^(BOOL success, SKTopicDetail *topicDetail) {
        _topicDetail = topicDetail;
        [_collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _topicDetail.user_comment.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NZLabDetialCollectionViewCell *cell =
    (NZLabDetialCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_topicDetail.user_comment[indexPath.row].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    cell.usernameLabel.text = _topicDetail.user_comment[indexPath.row].user_name;
    [cell setComment:_topicDetail.user_comment[indexPath.row].user_comment];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        [((CHTCollectionViewWaterfallHeader*)reusableView).mImageView sd_setImageWithURL:[NSURL URLWithString:_topicDetail.topic_detail.topic_detail_pic] placeholderImage:[UIImage imageNamed:@"img_labdetail_loading"]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterArticle)];
        tapGesture.numberOfTapsRequired = 1;
        [reusableView addGestureRecognizer:tapGesture];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize titleSize = [_topicDetail.user_comment[indexPath.row].user_comment boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-30)/2-14, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PINGFANG_FONT_OF_SIZE(12)} context:nil].size;
    return CGSizeMake((self.view.width-30)/2, titleSize.height+44);
}

#pragma mark - Actions

- (void)enterArticle {
    HTWebController *controller = [[HTWebController alloc] initWithURLString:[NSString stringWithFormat:@"https://admin.90app.tv/Home/TopicArticle/topic_article_detail/topic_id/%@.html", _topicID]];
    controller.type = 1;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)submitButtonClick:(UIButton*)sender {
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
//    transition.subtype = kCATransitionFromTop;     //出现的位置
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    
//    [self.navigationController pushViewController:controller animated:NO];
    NZSubmitCommentViewController *controller = [[NZSubmitCommentViewController alloc] initWithTopicID:_topicID];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeDimmingView {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
}

#pragma mark - 分享

- (void)onClickShareButton:sender {
    [self showShareView];
}

- (void)showShareView {
    if (_shareView == nil) {
        [self createShareView];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _shareView.alpha = 0.9;
                     }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.3
                     animations:^{
                         _shareView.alpha = 0;
                     }];
}

- (void)createShareView {
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_shareView];
    _shareView.backgroundColor = [UIColor blackColor];
    _shareView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)];
    [_shareView addGestureRecognizer:tap];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sharepage_text"]];
    [_shareView addSubview:titleImageView];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat"] forState:UIControlStateNormal];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat_highlight"] forState:UIControlStateHighlighted];
    [self.wechatButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton sizeToFit];
    self.wechatButton.tag = HTButtonTypeWechat;
    self.wechatButton.alpha = 1;
    [_shareView addSubview:self.wechatButton];
    
    self.momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle"] forState:UIControlStateNormal];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle_highlight"] forState:UIControlStateHighlighted];
    [self.momentButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentButton sizeToFit];
    self.momentButton.tag = HTButtonTypeMoment;
    self.momentButton.alpha = 1;
    [_shareView addSubview:self.momentButton];
    
    self.weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo"] forState:UIControlStateNormal];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo_highlight"] forState:UIControlStateHighlighted];
    [self.weiboButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton sizeToFit];
    self.weiboButton.tag = HTButtonTypeWeibo;
    self.weiboButton.alpha = 1;
    [_shareView addSubview:self.weiboButton];
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq"] forState:UIControlStateNormal];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq_highlight"] forState:UIControlStateHighlighted];
    [self.qqButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqButton sizeToFit];
    self.qqButton.tag = HTButtonTypeQQ;
    self.qqButton.alpha = 1;
    [_shareView addSubview:self.qqButton];
    
    __weak UIView *weakShareView = _shareView;
    
    float padding = (SCREEN_WIDTH - self.wechatButton.width * 4) / 5;
    //    float iconWidth = self.wechatButton.width;
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakShareView.mas_left).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wechatButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_momentButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weiboButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_wechatButton.mas_top).mas_offset(-36);
        make.centerX.equalTo(weakShareView);
    }];
}

- (void)showSharePromptView {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         alphaView.alpha = 0.6;
                     }];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_share"]];
    promptImageView.center = _dimmingView.center;
    [_dimmingView addSubview:promptImageView];
}

- (void)sharedQuestion {
//    [self showSharePromptView];
}

- (void)shareWithThirdPlatform:(UIButton *)sender {
    [TalkingData trackEvent:@"share"];
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeWechat: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            NSArray *imageArray = @[self.topicDetail.topic_detail.topic_detail_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_topicTitle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.topicID)]
                                                  title:nil
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     DLog(@"State -> %lu", (unsigned long)state);
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeMoment: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.topicDetail.topic_detail.topic_detail_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:nil
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.topicID)]
                                                  title:_topicTitle
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeWeibo: {
            if (![WeiboSDK isWeiboAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.topicDetail.topic_detail.topic_detail_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@ 来自@九零APP",_topicTitle, SHARE_URL(self.topicID)]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.topicID)]
                                                  title:nil
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeQQ: {
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.topicDetail.topic_detail.topic_detail_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_topicTitle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.topicID)]
                                                  title:nil
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - ToolMethod

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],
            result[1],
            result[2],
            result[3],
            result[4],
            result[5],
            result[6],
            result[7],
            result[8],
            result[9],
            result[10],
            result[11],
            result[12],
            result[13],
            result[14],
            result[15]];
}


@end
