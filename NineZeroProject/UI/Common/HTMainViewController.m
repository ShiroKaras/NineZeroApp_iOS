//
//  HTMainViewController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/17.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMainViewController.h"
#import "HTMascotDisplayController.h"
#import "HTPreviewCardController.h"
#import "HTRelaxController.h"
#import "HTRelaxCoverController.h"
#import "HTProfilePopView.h"

#define USER_NEW_CARD

CGFloat alphaDark = 0.3;
CGFloat alphaLight = 1.0;

@interface HTMainViewController () <HTProfilePopViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *mascotButton;
@property (weak, nonatomic) IBOutlet UIButton *meButton;

@end

@implementation HTMainViewController {
    UIViewController *_currentViewController;
    HTPreviewCardController *_cardController;
    HTMascotDisplayController *_mascotController;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cardController = [[HTPreviewCardController alloc] init];
    _mascotController = [[HTMascotDisplayController alloc] init];
    [_mascotController view]; //提前调用viewDidLoad
#ifdef USER_NEW_CARD
    [self changedToViewController:_cardController];
#else
    [self changedToViewController:_preViewController];
#endif
}

- (void)changedToViewController:(UIViewController *)viewController {
    if (_currentViewController) {
        [_currentViewController willMoveToParentViewController:nil]; //1
        [_currentViewController.view removeFromSuperview]; //2
        [_currentViewController removeFromParentViewController]; //3
    }
    if ([viewController isKindOfClass:[HTPreviewCardController class]]) {
        _mainButton.alpha = alphaLight;
        _mascotButton.alpha = alphaDark;
        _meButton.alpha = alphaDark;
    } else if ([viewController isKindOfClass:[HTMascotDisplayController class]]) {
        _mainButton.alpha = alphaDark;
        _mascotButton.alpha = alphaLight;
        _meButton.alpha = alphaDark;
    }
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [self.view sendSubviewToBack:viewController.view];
    _currentViewController = viewController;
}

- (void)loadResource {
    [_mascotController view];
}

- (void)showBottomButton:(BOOL)show {
    _mainButton.hidden = !show;
    _mascotButton.hidden = !show;
    _meButton.hidden = !show;
}

- (void)showBackToToday:(BOOL)show {
    if (show) {
        [_mainButton setImage:[UIImage imageNamed:@"tab_back_today"] forState:UIControlStateNormal];
        _mainButton.tag = 1000;
    } else {
        [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        _mainButton.tag = 0;
    }
}

#pragma mark - Action

- (IBAction)didClickMainButton:(id)sender {
    [self changedToViewController:_cardController];
    if([(UIButton *)sender tag] == 1000) {
        [_cardController backToToday];
    } else {
        [self changedToViewController:_cardController];
    }
}

- (IBAction)didClickMascotButton:(id)sender {
    [self showBackToToday:NO];
    if ([_currentViewController isKindOfClass:[HTMascotDisplayController class]]) return;
    [self changedToViewController:_mascotController];
    [_mascotController reloadDisplayMascots];
}

- (IBAction)didClickMeButton:(id)sender {
    [self showBackToToday:NO];
    
    if ([self.view viewWithTag:1234]) {
        [[self.view viewWithTag:1234] removeFromSuperview];
        [self profilePopViewWillDismiss:[self.view viewWithTag:1234]];
    } else {
        HTProfilePopView *popView = [[HTProfilePopView alloc] initWithFrame:CGRectZero];
        popView.delegate = self;
        popView.tag = 1234;
        [self.view addSubview:popView];
        [self.view bringSubviewToFront:self.meButton];
        _meButton.alpha = alphaLight;
        _mainButton.alpha = alphaDark;
        _mascotButton.alpha = alphaDark;
    }
}

#pragma mark - HTProfilePopViewDelegate

- (void)profilePopViewWillDismiss:(HTProfilePopView *)popView {
    _meButton.alpha = alphaDark;
    if (_currentViewController == _cardController) {
        _mainButton.alpha = alphaLight;
        _mascotButton.alpha = alphaDark;
    } else {
        _mainButton.alpha = alphaDark;
        _mascotButton.alpha = alphaLight;
    }
}

@end
