//
//  SKMascotIndexViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKMascotIndexViewController.h"
#import "HTUIHeader.h"

#import "SKMascotView.h"
#import "SKMascotAlbumView.h"
#import "SKMascotFightViewController.h"

#define MASCOT_VIEW_DEFAULT 100

@interface SKMascotIndexViewController () <UIScrollViewDelegate, SKMascotFightViewDelegate>

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *fightButton;        //战斗按钮
@property (nonatomic, strong) UIButton *mascotdexButton;    //图鉴按钮
@property (nonatomic, strong) UIButton *skillButton;        //技能按钮
@property (nonatomic, strong) UIButton *infoButton;         //信息按钮
@property (nonatomic, strong) UIView *redFlag_album;        //图鉴标记
@property (nonatomic, strong) UIView *redFlag_skill;        //技能标记

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *animationImages;     //序列帧

@property (nonatomic, strong) NSArray<SKPet*>   *mascotArray;

@property (nonatomic, strong) UIView *guideView;

@property (nonatomic, strong) UIView *HUDView;
@property (nonatomic, strong) UIImageView *HUDImageView;
@end

@implementation SKMascotIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"lingzaipage"];
    for (int i=1; i<7; i++) {
        if (self.mascotArray[i].user_haved) {
            [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) showDefaultImage];
        } else {
            [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) hide];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"lingzaipage"];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentIndex"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    //更新个人主页信息
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) { }];
    [[[SKServiceManager sharedInstance] mascotService] getMascotsCallback:^(BOOL success, NSArray<SKPet *> *mascotArray) {
        self.mascotArray = mascotArray;
        [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT]) showDefault];
        for (int i=1; i<7; i++) {
            if (self.mascotArray[i].user_haved) {
                [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) showDefaultImage];
            } else {
                [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) hide];
            }
        }
        [self hideHUD];
    }];
    
    _redFlag_album.hidden = !HAVE_NEW_MASCOT;
    RESET_NEW_MASCOT;
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    WS(weakSelf);
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 7, SCREEN_HEIGHT);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.bounces = NO;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    _typeArray = @[@(SKMascotTypeDefault), @(SKMascotTypeSloth), @(SKMascotTypePride), @(SKMascotTypeWrath),@(SKMascotTypeGluttony), @(SKMascotTypeLust), @(SKMascotTypeEnvy)];
    _mascotNameArray = @[@"lingzai", @"sloth", @"pride", @"wrath", @"gluttony",@"lust", @"envy"];
    
    for (int i = 0; i<7; i++) {
        SKMascotView *mascotView = [[SKMascotView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[i] integerValue]];
        mascotView.tag = 100+i;
        [_mScrollView addSubview:mascotView];
    }
    
    //按钮组
    _fightButton = [UIButton new];
    [_fightButton addTarget:self action:@selector(fightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _fightButton.hidden = YES;
    [self.view addSubview:_fightButton];
    [_fightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@70);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30);
    }];
    
    _mascotdexButton = [UIButton new];
    [_mascotdexButton addTarget:self action:@selector(mascotdexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums"] forState:UIControlStateNormal];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_mascotdexButton];
    [_mascotdexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.left.equalTo(@16);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-12);
    }];
    
    _skillButton = [UIButton new];
    [_skillButton addTarget:self action:@selector(skillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skillButton];
    [self updateButtonWithIndex:0];
    [_skillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-12);
    }];
    
    _infoButton = [UIButton new];
    [_infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info"] forState:UIControlStateNormal];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info_highlight"] forState:UIControlStateHighlighted];
    [_infoButton sizeToFit];
    [self.view addSubview:_infoButton];
    [_infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
    
    _redFlag_album = [UIView new];
    _redFlag_album.backgroundColor = COMMON_RED_COLOR;
    _redFlag_album.layer.cornerRadius = 6;
    _redFlag_album.hidden = YES;
    [self.view addSubview:_redFlag_album];
    [_redFlag_album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.top.equalTo(_mascotdexButton);
        make.right.equalTo(_mascotdexButton);
    }];
    
    _redFlag_skill = [UIView new];
    _redFlag_skill.backgroundColor = COMMON_RED_COLOR;
    _redFlag_skill.layer.cornerRadius = 6;
    _redFlag_skill.hidden = YES;
    [self.view addSubview:_redFlag_skill];
    [_redFlag_skill mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.top.equalTo(_skillButton);
        make.right.equalTo(_skillButton);
    }];
    
    if (FIRST_LAUNCH_MASCOTVIEW) {
        EVER_LAUNCHED_MASCOTVIEW
        
        _guideView = [[UIView alloc] initWithFrame:self.view.bounds];
        _guideView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_guideView];
        
        UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = 0.9;
        [_guideView addSubview:alphaView];
        
        UIImageView *guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_guide"]];
        guideImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_guideView addSubview:guideImageView];
        guideImageView.width = ROUND_HEIGHT_FLOAT(200);
        guideImageView.height = ROUND_HEIGHT_FLOAT(568);
        guideImageView.right = self.view.right;
        guideImageView.top = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGuideView)];
        tap.numberOfTapsRequired = 1;
        [_guideView addGestureRecognizer:tap];
        
        UILabel *label = [UILabel new];
        label.text = @"点击任意区域关闭";
        label.textColor = [UIColor colorWithHex:0xa2a2a2];
        label.font = PINGFANG_FONT_OF_SIZE(12);
        [label sizeToFit];
        [_guideView addSubview:label];
        label.centerX = _guideView.centerX;
        label.bottom = _guideView.bottom -16;
    }
    
    _HUDView = [[UIView alloc] initWithFrame:self.view.frame];
    _HUDView.backgroundColor = [UIColor blackColor];
    NSInteger count = 40;
    NSMutableArray *images = [NSMutableArray array];
    CGFloat length = 156;
    _HUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - length / 2, SCREEN_HEIGHT / 2 - length / 2, length, length)];
    _HUDImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_0000"]];
    for (int i = 0; i != count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loader_png_00%02d", i]];
        [images addObject:image];
    }
    _HUDImageView.animationImages = images;
    _HUDImageView.animationDuration = 2.0;
    _HUDImageView.animationRepeatCount = 0;
    [_HUDView addSubview:_HUDImageView];
    
    [self showHUD];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
        [self hideHUD];
    } else {
        [self loadData];
    }
}

- (void)showHUD {
    [AppDelegateInstance.window addSubview:_HUDView];
    _HUDView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _HUDView.alpha = 1;
        [_HUDImageView startAnimating];
    }];
}

- (void)hideHUD {
    [_HUDView removeFromSuperview];
}

- (void)removeGuideView {
    [_guideView removeFromSuperview];
}

- (void)skillButtonClick:(UIButton*)sender {
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[UD objectForKey:kMascots_Dict]];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:tempDict[[[SKStorageManager sharedInstance] getUserID]]];
    [tempArray replaceObjectAtIndex:self.currentIndex withObject:[NSNumber numberWithInteger:[self.mascotArray[self.currentIndex].pet_family_num integerValue]]];
    [tempDict setValue:tempArray forKey:[[SKStorageManager sharedInstance] getUserID]];
    [UD setObject:tempDict forKey:kMascots_Dict];
    _redFlag_skill.hidden = YES;
    
    SKMascotSkillView *skillView = [[SKMascotSkillView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[self.currentIndex] integerValue] isHad:self.mascotArray[self.currentIndex].user_haved];
    skillView.alpha = 0;
    [self.view addSubview:skillView];
    [UIView animateWithDuration:0.3 animations:^{
        skillView.alpha = 1;
    }];
}

- (void)infoButtonClick:(UIButton *)sender {
    SKMascotInfoView *infoView = [[SKMascotInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[self.currentIndex] integerValue]];
    infoView.alpha = 0;
    [self.view addSubview:infoView];
    [UIView animateWithDuration:0.3 animations:^{
        infoView.alpha = 1;
    }];
}

- (void)mascotdexButtonClick:(UIButton*)sender {
    _redFlag_album.hidden = YES;
    SKMascotAlbumView *mascotAlbumView = [[SKMascotAlbumView alloc] initWithFrame:self.view.bounds withMascotArray:self.mascotArray];
    mascotAlbumView.alpha = 0;
    [self.view addSubview:mascotAlbumView];
    [UIView animateWithDuration:0.3 animations:^{
        mascotAlbumView.alpha = 1;
    }];
}

- (void)fightButtonClick:(UIButton *)sender {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
        [alertView show];
    }else {
        SKMascotFightViewController *controller = [[SKMascotFightViewController alloc] initWithMascot:self.mascotArray[self.currentIndex]];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - SKMascotFightViewDelegate

- (void)didDismissMascotFightViewController:(SKMascotFightViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        [self loadData];
    }];
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
    if(point.x>7*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*7;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    self.currentIndex = round(point.x/(SCREEN_WIDTH));
    [self updateButtonWithIndex:self.currentIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateMascotImageWithIndex:self.currentIndex];
}

- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == SKMascotTypeDefault) {
        _fightButton.hidden = YES;
        _redFlag_skill.hidden = YES;
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill"] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill_highlight"] forState:UIControlStateHighlighted];
    } else {
        _fightButton.hidden = NO;
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
        if (self.mascotArray[index].user_haved) {
            _fightButton.alpha = 1;
            _fightButton.enabled = YES;
        } else {
            _fightButton.alpha = 0.4;
            _fightButton.enabled = NO;
        }
        
        //判断是否有新的道具
        _redFlag_skill.hidden = [self.mascotArray[index].pet_family_num integerValue] > [[UD objectForKey:kMascots_Dict][[[SKStorageManager sharedInstance] getUserID]][index] integerValue]? NO:YES;
    }
}

- (void)updateMascotImageWithIndex:(NSInteger)index {
    if (self.currentIndex == SKMascotTypeDefault) {
        [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT]) showDefault];
    } else {
        for (int i=0; i<7; i++) {
            if (self.mascotArray[i].user_haved) {
                if (i==self.currentIndex) {
                    [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) showDefault];
                } else {
                    [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+i]) showDefaultImage];
                }
            } else {
//                [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+self.currentIndex]) hide];
            }
        }
    }
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}
@end
