//
//  HTMainViewController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMainViewController.h"
#import "HTPreviewQuestionController.h"
#import "HTMascotDisplayController.h"
#import "HTRelaxController.h"
#import "HTRelaxCoverController.h"
#import "HTProfilePopView.h"

CGFloat alphaDark = 0.3;
CGFloat alphaLight = 1.0;

@interface HTMainViewController () <HTPreviewQuestionControllerDelegate, HTProfilePopViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *mascotButton;
@property (weak, nonatomic) IBOutlet UIButton *meButton;

@end

@implementation HTMainViewController {
    UIViewController *_currentViewController;
    HTPreviewQuestionController *_preViewController;
    HTMascotDisplayController *_mascotController;
}

- (instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _preViewController = [[HTPreviewQuestionController alloc] init];
    _preViewController.delegate = self;
    _mascotController = [[HTMascotDisplayController alloc] init];
    [self changedToViewController:_preViewController];
}

- (void)changedToViewController:(UIViewController *)viewController {
    if (_currentViewController) {
        [_currentViewController willMoveToParentViewController:nil]; //1
        [_currentViewController.view removeFromSuperview]; //2
        [_currentViewController removeFromParentViewController]; //3
    }
    if ([viewController isKindOfClass:[HTPreviewQuestionController class]]) {
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

#pragma mark - Action

- (IBAction)didClickMainButton:(id)sender {
    if([(UIButton *)sender tag] == 1000) {
        if (_preViewController) {
            [_preViewController goToToday];
        }
    } else {
        if ([_currentViewController isKindOfClass:[HTPreviewQuestionController class]]) return;
        [self changedToViewController:_preViewController];
    }
}

- (IBAction)didClickMascotButton:(id)sender {
    [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
    _mainButton.tag = 0;
    if ([_currentViewController isKindOfClass:[HTMascotDisplayController class]]) return;
    [self changedToViewController:_mascotController];
    [_mascotController reloadDisplayMascots];
}

- (IBAction)didClickMeButton:(id)sender {
    [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
    _mainButton.tag = 0;
    
    HTProfilePopView *popView = [[HTProfilePopView alloc] initWithFrame:CGRectZero];
    popView.delegate = self;
    [self.view addSubview:popView];
    [self.view bringSubviewToFront:self.meButton];
    _meButton.alpha = alphaLight;
    _mainButton.alpha = alphaDark;
    _mascotButton.alpha = alphaDark;
}

#pragma mark - HTProfilePopViewDelegate

- (void)profilePopViewWillDismiss:(HTProfilePopView *)popView {
    _meButton.alpha = alphaDark;
    if (_currentViewController == _preViewController) {
        _mainButton.alpha = alphaLight;
        _mascotButton.alpha = alphaDark;
    } else {
        _mainButton.alpha = alphaDark;
        _mascotButton.alpha = alphaLight;
    }
}

#pragma mark HTPreviewQuestionController Delegate

- (void)previewController:(HTPreviewQuestionController *)previewController shouldShowGoBackItem:(BOOL)needShow {
    if (needShow) {
        [_mainButton setImage:[UIImage imageNamed:@"tab_back_today"] forState:UIControlStateNormal];
        _mainButton.tag = 1000;
    } else {
        [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        _mainButton.tag = 0;
    }
}

@end
